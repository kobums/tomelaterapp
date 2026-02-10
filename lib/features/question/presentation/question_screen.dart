import 'package:app/features/question/presentation/question_view_model.dart';
import 'package:app/features/question/presentation/widgets/question_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class QuestionScreen extends ConsumerStatefulWidget {
  const QuestionScreen({super.key});

  @override
  ConsumerState<QuestionScreen> createState() => _QuestionScreenState();
}

class _QuestionScreenState extends ConsumerState<QuestionScreen> {
  final _answerController = TextEditingController();
  bool _isPublic = false;

  @override
  void dispose() {
    _answerController.dispose();
    super.dispose();
  }

  void _submit() async {
    if (_answerController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('답변을 입력해주세요.')),
      );
      return;
    }

    final success = await ref
        .read(questionViewModelProvider.notifier)
        .submitAnswer(_answerController.text, _isPublic);

    if (success) {
      _answerController.clear();
      // View model will update state to reveal "Answered" section
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(questionViewModelProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('To Me, Later')),
      backgroundColor: Colors.grey.shade50, // Light background for contrast
      body: state.isLoading
          ? const Center(child: CircularProgressIndicator())
          : state.error != null
              ? Center(child: Text(state.error!))
              : state.question == null
                  ? const Center(child: Text('오늘의 질문이 없습니다.'))
                  : SingleChildScrollView(
                      primary: false, // Fix for iOS tap-to-scroll conflict
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          QuestionCard(content: state.question!.content),
                          const SizedBox(height: 24),
                          if (state.existingAnswer != null) ...[
                            _buildAnsweredSection(state.existingAnswer!.content),
                            SizedBox(height: 80),
                          ]
                          else
                            _buildAnswerForm(state.isSubmitting),
                        ],
                      ),
                    ),
    );
  }

  Widget _buildAnsweredSection(String answer) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: const Color(0xFFECFDF5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFD1FAE5)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            offset: const Offset(0, 1),
            blurRadius: 2,
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: const BoxDecoration(
              color: Color(0xFFD1FAE5),
              shape: BoxShape.circle,
            ),
            child: const Center(child: Text('🌿', style: TextStyle(fontSize: 24))),
          ),
          const SizedBox(height: 16),
          const Text(
            'Answered',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF064E3B),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            '"$answer"',
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 16,
              color: Color(0xFF065F46),
              fontStyle: FontStyle.italic,
              height: 1.6,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'SEE YOU NEXT YEAR',
            style: TextStyle(
              fontSize: 12,
              color: Color(0xFF059669),
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnswerForm(bool isSubmitting) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 15,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'YOUR ANSWER',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Color(0xFF374151),
              letterSpacing: 0.8,
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _answerController,
            maxLines: 8,
            decoration: InputDecoration(
              hintText: 'Write your thoughts here...',
              filled: true,
              fillColor: const Color(0xFFF9FAFB),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Color(0xFF6366F1), width: 2),
              ),
            ),
            style: const TextStyle(
              fontSize: 16,
              height: 1.6,
              fontFamily: 'Georgia',
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Checkbox(
                value: _isPublic,
                onChanged: (value) {
                  setState(() {
                    _isPublic = value ?? false;
                  });
                },
                activeColor: const Color(0xFF6366F1),
              ),
              const Expanded(
                child: Text(
                  'Make this answer public (share with others)',
                  style: TextStyle(color: Color(0xFF4B5563)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: isSubmitting ? null : _submit,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF4F46E5),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 4,
            ),
            child: isSubmitting
                ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                  )
                : const Text(
                    'Submit to Future Me',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
