import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../viewmodels/search_viewmodel.dart';
import '../widgets/hotel_card.dart';
import '../widgets/loading_shimmer.dart';
import '../widgets/error_widget.dart' as error_widget;

class SearchResultsPage extends StatefulWidget {
  final String query;
  
  const SearchResultsPage({
    super.key,
    required this.query,
  });
  
  @override
  State<SearchResultsPage> createState() => _SearchResultsPageState();
}

class _SearchResultsPageState extends State<SearchResultsPage> {
  late ScrollController _scrollController;
  
  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_onScroll);
    
    // Load initial search results
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SearchViewModel>().searchHotels(widget.query);
    });
  }
  
  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
  
  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent * 0.8) {
      final viewModel = context.read<SearchViewModel>();
      if (!viewModel.isLoadingMore && viewModel.hasMore) {
        viewModel.loadMore();
      }
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search: ${widget.query}'),
      ),
      body: Consumer<SearchViewModel>(
        builder: (context, viewModel, child) {
          // Initial loading
          if (viewModel.isLoading && viewModel.hotels.isEmpty) {
            return const LoadingShimmer();
          }
          
          // Error state
          if (viewModel.errorMessage != null && viewModel.hotels.isEmpty) {
            return error_widget.ErrorDisplay(
              message: viewModel.errorMessage!,
              onRetry: () {
                viewModel.searchHotels(widget.query);
              },
            );
          }
          
          // Empty state
          if (viewModel.hotels.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.search_off,
                    size: 64.sp,
                    color: Colors.grey[400],
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    'No results found for "${widget.query}"',
                    style: TextStyle(
                      fontSize: 18.sp,
                      color: Colors.grey[600],
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    'Try a different search term',
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: Colors.grey[500],
                    ),
                  ),
                ],
              ),
            );
          }
          
          // Results list
          return Column(
            children: [
              // Results count
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(16.w),
                color: Colors.grey[100],
                child: Text(
                  '${viewModel.hotels.length} results found',
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: Colors.grey[700],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              
              // Hotels list
              Expanded(
                child: ListView.builder(
                  controller: _scrollController,
                  itemCount: viewModel.hotels.length + (viewModel.isLoadingMore ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index == viewModel.hotels.length) {
                      // Loading more indicator
                      return Center(
                        child: Padding(
                          padding: EdgeInsets.all(16.w),
                          child: CircularProgressIndicator(),
                        ),
                      );
                    }
                    
                    final hotel = viewModel.hotels[index];
                    return HotelCard(hotel: hotel);
                  },
                ),
              ),
              
              // Error message banner
              if (viewModel.errorMessage != null && viewModel.hotels.isNotEmpty)
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(12.w),
                  color: Colors.red[50],
                  child: Row(
                    children: [
                      Icon(Icons.error_outline, color: Colors.red[700], size: 20.sp),
                      SizedBox(width: 8.w),
                      Expanded(
                        child: Text(
                          viewModel.errorMessage!,
                          style: TextStyle(color: Colors.red[700], fontSize: 12.sp),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          viewModel.clearError();
                        },
                        child: Text('Dismiss', style: TextStyle(fontSize: 12.sp)),
                      ),
                    ],
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
