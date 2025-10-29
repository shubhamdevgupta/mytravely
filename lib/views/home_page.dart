import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../viewmodels/home_viewmodel.dart';
import '../viewmodels/auth_viewmodel.dart';
import '../viewmodels/search_viewmodel.dart';
import '../core/constants.dart';
import '../widgets/hotel_card.dart';
import '../widgets/search_bar.dart';
import '../widgets/loading_shimmer.dart';
import '../widgets/error_widget.dart' as error_widget;
import '../utils/debouncer.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late TextEditingController _searchController;
  late Debouncer _debouncer;
  bool _showSuggestions = false;
  
  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _debouncer = Debouncer(delay: const Duration(milliseconds: 350));
  }
  
  @override
  void dispose() {
    _searchController.dispose();
    _debouncer.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MyTravely'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              context.read<AuthViewModel>().signOut();
              Navigator.pushReplacementNamed(context, AppConstants.signInRoute);
            },
          ),
        ],
      ),
      body: Consumer<HomeViewModel>(
        builder: (context, viewModel, child) {
          if (viewModel.isLoading) {
            return const LoadingShimmer();
          }
          
          if (viewModel.errorMessage != null) {
            return error_widget.ErrorDisplay(
              message: viewModel.errorMessage!,
              onRetry: () {
                // Retry loading
              },
            );
          }
          
          return Column(
            children: [
              CustomSearchBar(
                controller: _searchController,
                hintText: 'Search by name, city, state, or country',
                onChanged: (value) {
                  viewModel.updateSearchQuery(value);
                  if (value.trim().length >= 2) {
                    _debouncer(() {
                      context.read<SearchViewModel>().searchHotels(value, isNewSearch: true);
                      setState(() {
                        _showSuggestions = true;
                      });
                    });
                  } else {
                    setState(() {
                      _showSuggestions = false;
                    });
                  }
                },
                onSearch: () {
                  if (_searchController.text.isNotEmpty) {
                    Navigator.pushNamed(
                      context,
                      AppConstants.searchResultsRoute,
                      arguments: _searchController.text,
                    );
                    setState(() {
                      _showSuggestions = false;
                    });
                  }
                },
              ),
              if (_showSuggestions)
                Consumer<SearchViewModel>(
                  builder: (context, sVm, _) {
                    final suggestions = sVm.hotels.take(5).toList();
                    if (suggestions.isEmpty) return const SizedBox.shrink();
                    return Container(
                      margin: EdgeInsets.symmetric(horizontal: 16.w),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          )
                        ],
                      ),
                      child: ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: suggestions.length,
                        separatorBuilder: (_, __) => Divider(height: 1, color: Colors.grey[200]),
                        itemBuilder: (context, index) {
                          final h = suggestions[index];
                          return ListTile(
                            leading: const Icon(Icons.search),
                            title: Text(h.name, maxLines: 1, overflow: TextOverflow.ellipsis),
                            subtitle: (h.city.isNotEmpty || h.state.isNotEmpty)
                                ? Text('${h.city}${h.city.isNotEmpty && h.state.isNotEmpty ? ', ' : ''}${h.state}',
                                    maxLines: 1, overflow: TextOverflow.ellipsis)
                                : null,
                            onTap: () {
                              _searchController.text = h.name;
                              Navigator.pushNamed(
                                context,
                                AppConstants.searchResultsRoute,
                                arguments: h.name,
                              );
                              setState(() {
                                _showSuggestions = false;
                              });
                            },
                          );
                        },
                      ),
                    );
                  },
                ),
              Expanded(
                child: viewModel.filteredHotels.isEmpty
                    ? Center(
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
                              'No hotels found',
                              style: TextStyle(
                                fontSize: 18.sp,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        itemCount: viewModel.filteredHotels.length,
                        itemBuilder: (context, index) {
                          final hotel = viewModel.filteredHotels[index];
                          return HotelCard(hotel: hotel);
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }
}
