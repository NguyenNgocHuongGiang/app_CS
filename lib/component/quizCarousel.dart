import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:html_unescape/html_unescape.dart';

class QuizCarouselWidget extends StatefulWidget {
  final String quizContent; // Dữ liệu JSON dạng String

  const QuizCarouselWidget({Key? key, required this.quizContent})
      : super(key: key);

  @override
  _QuizCarouselWidgetState createState() => _QuizCarouselWidgetState();
}

class _QuizCarouselWidgetState extends State<QuizCarouselWidget> {
  late List<dynamic> quizData;
  final unescape = HtmlUnescape();
  final PageController _pageController = PageController();
  int currentPage = 0;

  // Lưu trữ đáp án được chọn cho mỗi câu hỏi (cho kiểu chọn 1 đáp án)
  Map<int, int> selectedAnswers = {};

  // Lưu trữ giá trị nhập cho câu hỏi fill_inblank
  // Key: questionIndex, Value: map<placeholderIndex, đáp án user chọn>
  Map<int, Map<int, String>> fillBlankAnswers = {};

  // Lưu trữ placeholderIndex nào đang được bấm (active) để gán đáp án
  int? activePlaceholderIndex;

  @override
  void initState() {
    super.initState();
    quizData = jsonDecode(widget.quizContent);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  /// Phân biệt hiển thị theo loại câu hỏi
  Widget _buildQuestionCard(Map<String, dynamic> question, int questionIndex) {
    final String maLoaiBaiTap = question['maLoaiBaiTap'] ?? "multiple_choice";
    switch (maLoaiBaiTap) {
      case "multiple_choice":
        return _buildMultipleChoiceCard(question, questionIndex);
      case "single_choice":
        return _buildSingleChoiceCard(question, questionIndex);
      case "fill_input":
        return _buildFillInputCard(question, questionIndex);
      case "fill_inblank":
        return _buildFillInBlankCard(question, questionIndex);
      default:
        return const Center(child: Text("Kiểu câu hỏi không xác định"));
    }
  }

  /// Widget hiển thị dạng multiple_choice
  Widget _buildMultipleChoiceCard(
      Map<String, dynamic> question, int questionIndex) {
    final String tieuDe = question['tieuDe'] ?? "";
    final String inPut = unescape.convert(question['inPut'] ?? "");
    final List<dynamic> dapAn = question['cauTraLoi'] ?? [];
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Card(
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                tieuDe,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                inPut,
                style: const TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 16),
              ...List.generate(dapAn.length, (answerIndex) {
                final String cauTraLoi = dapAn[answerIndex]['noiDung'] ?? "";
                bool isSelected = selectedAnswers[questionIndex] == answerIndex;
                return InkWell(
                  onTap: () {
                    setState(() {
                      selectedAnswers[questionIndex] = answerIndex;
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 12.0, horizontal: 8.0),
                    margin: const EdgeInsets.symmetric(vertical: 4.0),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? Colors.grey.withOpacity(0.4)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(8.0),
                      border: Border.all(
                        color: isSelected ? Colors.grey : Colors.grey.shade300,
                      ),
                    ),
                    child: Row(
                      children: [
                        isSelected
                            ? const Icon(Icons.check_box, color: Colors.green)
                            : const Icon(Icons.square_outlined,
                                color: Colors.grey),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            cauTraLoi,
                            style: const TextStyle(fontSize: 14),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  /// Widget hiển thị dạng single_choice
  Widget _buildSingleChoiceCard(
      Map<String, dynamic> question, int questionIndex) {
    final String tieuDe = question['tieuDe'] ?? "";
    final String inPut = unescape.convert(question['inPut'] ?? "");
    final List<dynamic> dapAn = question['dapAn'] ?? [];

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Card(
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                tieuDe,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                inPut,
                style: const TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 16),
              ...List.generate(dapAn.length, (answerIndex) {
                final String cauTraLoi = dapAn[answerIndex]['cauTraLoi'] ?? "";
                bool isSelected = selectedAnswers[questionIndex] == answerIndex;
                return InkWell(
                  onTap: () {
                    setState(() {
                      selectedAnswers[questionIndex] = answerIndex;
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 12.0, horizontal: 8.0),
                    margin: const EdgeInsets.symmetric(vertical: 4.0),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? Colors.grey.withOpacity(0.4)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(8.0),
                      border: Border.all(
                        color: isSelected ? Colors.grey : Colors.grey.shade300,
                      ),
                    ),
                    child: Row(
                      children: [
                        isSelected
                            ? const Icon(Icons.check_circle,
                                color: Colors.green)
                            : const Icon(Icons.circle_outlined,
                                color: Colors.grey),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            cauTraLoi,
                            style: const TextStyle(fontSize: 14),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  /// Widget hiển thị câu hỏi dạng fill_input
  Widget _buildFillInputCard(Map<String, dynamic> question, int questionIndex) {
    final String tieuDe = question['tieuDe'] ?? "";
    // Chuỗi code gốc
    final String rawInput = question['inPut'] ?? "";
    // Giải mã HTML
    final String inPut = unescape.convert(rawInput);

    // Kiểm tra placeholder
    if (!inPut.contains('♥')) {
      // Không có placeholder => hiển thị code bình thường
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          elevation: 4,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  tieuDe,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Container(
                  width: double.infinity,
                  color: Colors.grey[100],
                  padding: const EdgeInsets.all(8),
                  child: Text(
                    inPut,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black87,
                      fontFamily: 'monospace',
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    // Tách chuỗi làm 2 phần: trước placeholder, sau placeholder
    final parts = inPut.split('♥');
    final beforeText = parts[0];
    final afterText = parts.length > 1 ? parts[1] : "";

    // Tạo 1 TextEditingController để lưu giá trị user nhập
    final TextEditingController controller = TextEditingController();

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Card(
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Tiêu đề
              Text(
                tieuDe,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),

              // Vùng code
              Container(
                width: double.infinity,
                color: Colors.grey[100],
                padding: const EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Thay vì hiển thị 1 dòng, bạn có thể tách code ra nhiều dòng
                    // Tuỳ vào format code. Ở đây mình demo 1 dòng:

                    // Phần trước placeholder
                    Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Text(
                          beforeText,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.black87,
                            fontFamily: 'monospace',
                          ),
                        ),

                        // Ô để user nhập
                        Container(
                            height: 30,
                            width: 100, // Chiều rộng tuỳ ý
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            // decoration: BoxDecoration(
                            //   border: Border(
                            //       bottom: BorderSide(
                            //           color: Colors.black87, width: 1.5)),
                            // ),
                            child: TextField(
                              controller: controller,
                              decoration: const InputDecoration(
                                isDense: true,
                                border: OutlineInputBorder(),
                                // enabledBorder: OutlineInputBorder(
                                //   borderSide: BorderSide(
                                //       color: Colors.grey, width: 1.0),
                                // ),
                                // focusedBorder: OutlineInputBorder(
                                //   borderSide: BorderSide(
                                //       color: Colors.black, width: 1.0),
                                // ),
                                // hintText: "đáp án",
                              ),
                              style: const TextStyle(
                                fontSize: 14,
                                fontFamily: 'monospace',
                              ),
                              onChanged: (value) {
                                // Xử lý logic nếu cần
                              },
                            )),

                        // Phần sau placeholder
                        Text(
                          afterText,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.black87,
                            fontFamily: 'monospace',
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Widget hiển thị câu hỏi dạng fill_inblank
  Widget _buildFillInBlankCard(
      Map<String, dynamic> question, int questionIndex) {
    final String tieuDe = question['tieuDe'] ?? "";
    final String rawInput = question['inPut'] ?? "";
    final String decodeInput = unescape.convert(rawInput);

    // Danh sách đáp án hiển thị ở dưới (dưới dạng list string)
    final List<String> listAnswers = (question['cauTraLoi'] as List<dynamic>)
        .map((e) => e['noiDung'].toString())
        .toList();

    // Tách chuỗi theo placeholder
    final parts = decodeInput.split('♥');

    // Khởi tạo fillBlankAnswers[questionIndex] nếu chưa có
    fillBlankAnswers[questionIndex] ??= {};

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Card(
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Tiêu đề
              Text(
                tieuDe,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),

              // Khu vực hiển thị code + placeholder
              Container(
                width: double.infinity,
                color: Colors.grey[100],
                padding: const EdgeInsets.all(8),
                child: _buildCodeRichText(parts, questionIndex),
              ),

              const SizedBox(height: 16),

              // Hiển thị danh sách đáp án
              Text(
                "Chọn đáp án:",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueGrey[700],
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8.0,
                runSpacing: 8.0,
                children: listAnswers.map((answer) {
                  return ElevatedButton(
                    onPressed: () {
                      // Khi bấm 1 đáp án, nếu placeholder đang active, gán đáp án
                      if (activePlaceholderIndex != null) {
                        setState(() {
                          fillBlankAnswers[questionIndex]![
                              activePlaceholderIndex!] = answer;
                          // Tắt activePlaceholder sau khi chọn
                          activePlaceholderIndex = null;
                        });
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      side: const BorderSide(color: Colors.blueGrey, width: 1),
                    ),
                    child: Text(
                      answer,
                      style: const TextStyle(color: Colors.black87),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Hàm xây dựng RichText gồm text + placeholder “?”
  Widget _buildCodeRichText(List<String> parts, int questionIndex) {
    // Số placeholder = parts.length - 1
    List<InlineSpan> children = [];

    for (int i = 0; i < parts.length; i++) {
      // Thêm đoạn text
      children.add(
        TextSpan(
          text: parts[i],
          style: const TextStyle(color: Colors.black87),
        ),
      );

      // Thêm placeholder sau đoạn text (nếu chưa phải đoạn cuối)
      if (i < parts.length - 1) {
        final placeholderIndex = i;
        // print(11111111111111111);
        // print(fillBlankAnswers[questionIndex]);
        final userAnswer = fillBlankAnswers[questionIndex]?[placeholderIndex];

        children.add(
          WidgetSpan(
            alignment: PlaceholderAlignment.middle,
            child: GestureDetector(
              onTap: () {
                // Khi bấm vào placeholder, đánh dấu placeholderIndex đang active
                setState(() {
                  activePlaceholderIndex = placeholderIndex;
                });
              },
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 2),
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.yellow[200],
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(color: Colors.orange, width: 1),
                ),
                child: Text(
                  userAnswer ?? "?",
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        );
      }
    }

    return RichText(
      text: TextSpan(
        style: const TextStyle(fontSize: 14, fontFamily: 'monospace'),
        children: children,
      ),
    );
  }

  void _onBack() {
    if (currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _onNext() {
    if (currentPage < quizData.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _submitQuiz();
    }
  }

  void _submitQuiz() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Submit Quiz"),
        content: const Text("Bạn đã hoàn thành quiz!"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Đóng"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (quizData.isEmpty) {
      return const Center(child: Text("Không có dữ liệu quiz"));
    }

    return Column(
      children: [
        Expanded(
          child: PageView.builder(
            controller: _pageController,
            itemCount: quizData.length,
            onPageChanged: (index) {
              setState(() {
                currentPage = index;
                // Reset activePlaceholderIndex mỗi khi chuyển trang
                activePlaceholderIndex = null;
              });
            },
            itemBuilder: (context, index) {
              final question = quizData[index];
              return _buildQuestionCard(question, index);
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (currentPage > 0)
                ElevatedButton(
                  onPressed: _onBack,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    side: const BorderSide(color: Colors.amber, width: 2),
                  ),
                  child: const Text(
                    "Back",
                    style: TextStyle(color: Colors.amber),
                  ),
                )
              else
                const SizedBox(width: 100),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.amber,
                  border: Border.all(color: Colors.amber, width: 2),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  "${currentPage + 1}/${quizData.length}",
                  style: const TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
              ),
              ElevatedButton(
                onPressed: _onNext,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  side: const BorderSide(color: Colors.amber, width: 2),
                ),
                child: Text(
                  currentPage == quizData.length - 1 ? "Submit" : "Next",
                  style: const TextStyle(color: Colors.amber),
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}
