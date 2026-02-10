import 'package:app/shared/models/answer.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class HistoryDetailScreen extends StatelessWidget {
  final Answer answer;

  const HistoryDetailScreen({required this.answer, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black.withOpacity(0.4), // Dimmed background
      body: Stack(
        children: [
          // Close on tap outside
          GestureDetector(
            onTap: () => context.pop(),
            child: Container(color: Colors.transparent),
          ),
          Center(
            child: Container(
              width: MediaQuery.of(context).size.width * 0.9,
              constraints: const BoxConstraints(maxWidth: 600, maxHeight: 700),
              decoration: BoxDecoration(
                color: const Color(0xFFFDFBF7), // Warm paper color
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.25),
                    offset: const Offset(0, 25),
                    blurRadius: 50,
                    spreadRadius: -12,
                  ),
                ],
              ),
              child: Stack(
                children: [
                   // Stamp
                  Positioned(
                    top: 32,
                    right: 32,
                    child: Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        border: Border.all(color: const Color(0xFFE0E7FF), width: 2),
                        shape: BoxShape.circle,
                      ),
                      child: const Center(
                        child: Text(
                          '🕊️',
                          style: TextStyle(fontSize: 30),
                        ),
                      ),
                    ),
                  ),
                  
                  // Content
                  Padding(
                    padding: const EdgeInsets.all(40),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(height: 20),
                        const Text(
                          'Written on',
                          style: TextStyle(
                            color: Color(0xFF818CF8),
                            fontSize: 14,
                            fontStyle: FontStyle.italic,
                            fontFamily: 'Georgia', // Attempt to use Serif-like font
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _formatDate(answer.createdAt),
                          style: const TextStyle(
                            color: Color(0xFF1F2937),
                            fontSize: 24,
                            fontFamily: 'Pretendard', 
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                        const SizedBox(height: 16),
                        if (answer.question != null) ...[
                          Text(
                                  answer.question!.content,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF1F2937),
                                    height: 1.5,
                                    fontFamily: 'Pretendard',
                                  ),
                                ),
                          const SizedBox(height: 12),
                        ],
                        const Divider(color: Color(0xFFEEF2FF)),
                        const SizedBox(height: 16),
                        Expanded(
                          child: SingleChildScrollView(
                            child: Text(
                              answer.content,
                              style: const TextStyle(
                                color: Color(0xFF374151),
                                fontSize: 16,
                                height: 1.8, 
                                fontFamily: 'Pretendard', 
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        
                        // Footer
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'STATUS',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Color(0xFF9CA3AF),
                                    letterSpacing: 1.2,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  answer.isPublic ? 'Shared with the world' : 'Kept for myself',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontStyle: FontStyle.italic,
                                    color: Color(0xFF4B5563),
                                    fontFamily: 'Pretendard',
                                  ),
                                ),
                              ],
                            ),
                            TextButton(
                              onPressed: () => context.pop(),
                              style: TextButton.styleFrom(
                                backgroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(999),
                                  side: const BorderSide(color: Color(0xFFE5E7EB)),
                                ),
                              ),
                              child: const Text(
                                'Close Letter',
                                style: TextStyle(
                                  color: Color(0xFF4B5563),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  
                  // Decorative top edge line
                   Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      height: 4,
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Color(0xFFE0E7FF), Color(0xFFF3E8FF), Color(0xFFFCE7F3)],
                        ),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(8),
                          topRight: Radius.circular(8),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(String isoString) {
    try {
      final date = DateTime.parse(isoString);
      return DateFormat('MMMM d, yyyy').format(date);
    } catch (e) {
      return isoString;
    }
  }
}
