import 'package:app/features/history/presentation/history_view_model.dart';
import 'package:app/shared/models/answer.dart';
import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class HistoryScreen extends ConsumerStatefulWidget {
  const HistoryScreen({super.key});

  @override
  ConsumerState<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends ConsumerState<HistoryScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.hasClients &&
        _scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 200) {
      ref.read(historyViewModelProvider.notifier).loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(historyViewModelProvider);
    final notifier = ref.read(historyViewModelProvider.notifier);

    return PrimaryScrollController(
      controller: _scrollController,
      child: Scaffold(
        backgroundColor: const Color(0xFFF9FAFB),
        appBar: AppBar(
          title: const Text(
            'My History',
            style: TextStyle(
              fontFamily: 'Pretendard',
              fontWeight: FontWeight.w600,
              fontSize: 18,
              color: Color(0xFF1F2937),
            ),
          ),
          backgroundColor: const Color(0xFFF9FAFB),
          elevation: 0,
          scrolledUnderElevation: 0,
          centerTitle: true,
        ),
        body: state.isLoading && state.answers.isEmpty
            ? const Center(child: CircularProgressIndicator())
            : state.error != null && state.answers.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(state.error!, style: const TextStyle(color: Colors.red)),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: notifier.refresh,
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  )
                : state.answers.isEmpty
                    ? _buildEmptyState()
                    : CustomRefreshIndicator(
                        onRefresh: notifier.refresh,
                        builder: (context, child, controller) {
                          return Stack(
                            children: [
                              if (!controller.isIdle)
                                Positioned(
                                  top: 20 * controller.value,
                                  left: 0,
                                  right: 0,
                                  child: Center(
                                    child: SizedBox(
                                      width: 24,
                                      height: 24,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        value: controller.isLoading ? null : controller.value.clamp(0.0, 1.0),
                                        valueColor: const AlwaysStoppedAnimation<Color>(Colors.indigo),
                                      ),
                                    ),
                                  ),
                                ),
                              Transform.translate(
                                offset: Offset(0, 50 * controller.value),
                                child: child,
                              ),
                            ],
                          );
                        },
                        child: ListView.separated(
                          controller: _scrollController,
                          physics: const AlwaysScrollableScrollPhysics(),
                          padding: const EdgeInsets.fromLTRB(20, 10, 20, 100),
                          itemCount: state.answers.length + (state.isLoadingMore ? 1 : 0),
                          separatorBuilder: (context, index) => const SizedBox(height: 16),
                          itemBuilder: (context, index) {
                            if (index == state.answers.length) {
                               return const Center(
                                 child: Padding(
                                   padding: EdgeInsets.all(16.0),
                                   child: SizedBox(
                                     width: 24, 
                                     height: 24, 
                                     child: CircularProgressIndicator(
                                       strokeWidth: 2,
                                       valueColor: AlwaysStoppedAnimation<Color>(Colors.indigo),
                                     ),
                                   ),
                                 ),
                               );
                            }
                            final answer = state.answers[index];
                            return GestureDetector(
                              onTap: () {
                                context.push('/history/detail', extra: answer);
                              },
                              child: _HistoryCard(answer: answer),
                            );
                          },
                        ),
                      ),
      ),
    );
  }
}


  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.indigo.shade50,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.mail_outline_rounded,
              size: 48,
              color: Colors.indigo.shade300,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            '아직 작성된 편지가 없어요',
            style: TextStyle(
              fontFamily: 'Pretendard',
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade800,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '오늘의 질문에 답변하고\n미래의 나에게 편지를 보내보세요.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Pretendard',
              fontSize: 14,
              color: Colors.grey.shade500,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

class _HistoryCard extends StatelessWidget {
  final Answer answer;

  const _HistoryCard({required this.answer});

  String _formatDate(String isoString) {
    try {
      final date = DateTime.parse(isoString);
      return DateFormat('yyyy.MM.dd').format(date);
    } catch (e) {
      return isoString;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            offset: const Offset(0, 4),
            blurRadius: 16,
            spreadRadius: 0,
          ),
        ],
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Date Badge & Status
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.indigo.shade50,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    _formatDate(answer.createdAt),
                    style: TextStyle(
                      fontFamily: 'Pretendard',
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.indigo.shade400,
                    ),
                  ),
                ),
                Icon(
                  answer.isPublic ? Icons.public : Icons.lock_outline_rounded,
                  size: 16,
                  color: answer.isPublic ? Colors.blueGrey.shade300 : Colors.grey.shade300,
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Question
            if (answer.question != null) ...[
              Text(
                'Q. ${answer.question!.content}',
                style: const TextStyle(
                  fontFamily: 'Pretendard',
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1F2937),
                  height: 1.4,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 12),
            ],

            // Answer Preview
            Text(
              answer.content,
              style: const TextStyle(
                fontFamily: 'Pretendard',
                fontSize: 14,
                color: Color(0xFF6B7280),
                height: 1.6,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),

            const SizedBox(height: 16),

            // Bottom Actions (Optional, just visual hint)
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  'Read more',
                  style: TextStyle(
                    fontFamily: 'Pretendard',
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey.shade400,
                  ),
                ),
                const SizedBox(width: 4),
                Icon(
                  Icons.arrow_forward_rounded,
                  size: 14,
                  color: Colors.grey.shade400,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
