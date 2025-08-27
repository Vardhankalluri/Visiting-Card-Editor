
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

void main() => runApp(VisitingCardEditorApp());

class VisitingCardEditorApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Visiting Card Editor PRO',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
        ),
      ),
      home: VisitingCardScreen(),
    );
  }
}

class EditableDraggableText extends StatefulWidget {
  final String text;
  final double initialTop;
  final double initialLeft;
  final double cardWidth;
  final double cardHeight;
  final Function onDelete;
  final Function(String text, double top, double left, Color color, double size, bool bold, bool italic, String font) onUpdate;
  final Color initialColor;
  final double initialFontSize;
  final bool initialBold;
  final bool initialItalic;
  final String initialFont;

  const EditableDraggableText({
    required this.text,
    required this.initialTop,
    required this.initialLeft,
    required this.cardWidth,
    required this.cardHeight,
    required this.onDelete,
    required this.onUpdate,
    required this.initialColor,
    required this.initialFontSize,
    required this.initialBold,
    required this.initialItalic,
    required this.initialFont,
    Key? key,
  }) : super(key: key);

  @override
  _EditableDraggableTextState createState() => _EditableDraggableTextState();
}

class _EditableDraggableTextState extends State<EditableDraggableText> {
  late double top;
  late double left;
  late String text;
  late Color selectedColor;
  late double selectedFontSize;
  late bool isBold;
  late bool isItalic;
  late String selectedFont;


  final List<double> fontSizes = [8, 10, 12, 14, 16, 18, 20, 24, 28, 32]; // Extended font sizes

  final List<String> fonts = ['Roboto', 'Lobster', 'Open Sans', 'Oswald', 'Raleway', 'Pacifico', 'Playfair Display', 'Merriweather']; // Extended fonts

  @override
  void initState() {
    super.initState();

    top = widget.initialTop;
    left = widget.initialLeft;
    text = widget.text;
    selectedColor = widget.initialColor;
    selectedFontSize = widget.initialFontSize;
    isBold = widget.initialBold;
    isItalic = widget.initialItalic;
    selectedFont = widget.initialFont;
  }

  // Function to show the text editing dialog.
  void _editText() async {

    TextEditingController controller = TextEditingController(text: text);

    Color tempColor = selectedColor;
    double tempFontSize = selectedFontSize;
    bool tempBold = isBold;
    bool tempItalic = isItalic;
    String tempFont = selectedFont;

    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (context) {
        // StatefulBuilder allows updating the dialog UI dynamically.
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text("Edit Text"),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [

                    TextField(
                      controller: controller,
                      decoration: const InputDecoration(labelText: "Text Content"),
                    ),
                    const SizedBox(height: 20), // Spacer.
                    const Text("Select Color:", style: TextStyle(fontWeight: FontWeight.bold)),
                    // Changed PaletteType to .hueWheel for a circular color picker
                    ColorPicker(
                      pickerColor: tempColor,
                      onColorChanged: (color) {
                        setDialogState(() => tempColor = color);
                      },
                      pickerAreaHeightPercent: 0.8,
                      enableAlpha: true,
                      displayThumbColor: true,
                      showLabel: true,
                      paletteType: PaletteType.hueWheel, // Changed to Hue Wheel palette type
                    ),
                    const SizedBox(height: 20), // Spacer.
                    // Row to place Font Size and Font Family dropdowns side-by-side.
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: DropdownButtonFormField<double>(
                              isExpanded: true,
                              decoration: const InputDecoration(
                                labelText: "Font Size",
                                border: OutlineInputBorder(),
                              ),
                              value: tempFontSize,
                              items: fontSizes.map((size) {
                                return DropdownMenuItem(
                                  value: size,
                                  child: Text('Size ${size.toInt()}'),
                                );
                              }).toList(),
                              onChanged: (value) {
                                if (value != null) setDialogState(() => tempFontSize = value);
                              },
                            ),
                          ),
                          const SizedBox(width: 10), // Spacing between dropdowns.
                          Expanded(
                            child: DropdownButtonFormField<String>(
                              isExpanded: true,
                              decoration: const InputDecoration(
                                labelText: "Font Family",
                                border: OutlineInputBorder(),
                              ),
                              value: tempFont,
                              items: fonts.map((font) {
                                return DropdownMenuItem(
                                  value: font,
                                  child: Text(font, style: GoogleFonts.getFont(font)), // Display font name in its own style.
                                );
                              }).toList(),
                              onChanged: (value) {
                                if (value != null) setDialogState(() => tempFont = value);
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20), // Spacer.
                    // Row for Bold and Italic checkboxes, now with improved alignment.
                    Padding( // Added Padding to give some horizontal space from dialog edges.
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly, // Distribute space evenly.
                        children: [
                          Expanded( // Use Expanded to ensure checkboxes take equal space.
                            child: Row( // Nested Row for checkbox and text
                              mainAxisSize: MainAxisSize.min, // Keep it compact
                              children: [
                                Checkbox(
                                  value: tempBold,
                                  onChanged: (value) => setDialogState(() => tempBold = value!),
                                ),
                                const Text("Bold", style: TextStyle(fontSize: 14)),
                              ],
                            ),
                          ),
                          Expanded( // Use Expanded to ensure checkboxes take equal space.
                            child: Row( // Nested Row for checkbox and text
                              mainAxisSize: MainAxisSize.min, // Keep it compact
                              children: [
                                Checkbox(
                                  value: tempItalic,
                                  onChanged: (value) => setDialogState(() => tempItalic = value!),
                                ),
                                const Text("Italic", style: TextStyle(fontSize: 14)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context, {
                      "text": controller.text,
                      "color": tempColor,
                      "size": tempFontSize,
                      "bold": tempBold,
                      "italic": tempItalic,
                      "font": tempFont,
                      "delete": false, // Indicate not to delete.
                    });
                  },
                  child: const Text("Save"),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context, {"delete": true}),
                  child: const Text("Delete", style: TextStyle(color: Colors.red)),
                ),
              ],
            );
          },
        );
      },
    );

    if (result != null) {
      if (result["delete"] == true) {
        widget.onDelete(); // Call the delete callback.
      } else {
        setState(() {
          text = result["text"];
          selectedColor = result["color"];
          selectedFontSize = result["size"];
          isBold = result["bold"];
          isItalic = result["italic"];
          selectedFont = result["font"];

          widget.onUpdate(text, top, left, selectedColor, selectedFontSize, isBold, isItalic, selectedFont);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Construct the TextStyle based on the selected font properties.
    final textStyle = GoogleFonts.getFont(
      selectedFont,
      fontSize: selectedFontSize,
      fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
      fontStyle: isItalic ? FontStyle.italic : FontStyle.normal,
      color: selectedColor,
    );

    return Positioned(
      top: top,
      left: left,
      child: GestureDetector(
        onTap: _editText, // Open edit dialog on tap.
        onPanUpdate: (details) {
          final textPainter = TextPainter(
            text: TextSpan(text: text, style: textStyle),
            maxLines: 1,
            textDirection: TextDirection.ltr,
          )..layout();

          final width = textPainter.width;
          final height = textPainter.height;

          setState(() {
            left = (left + details.delta.dx).clamp(0.0, widget.cardWidth - width);
            top = (top + details.delta.dy).clamp(0.0, widget.cardHeight - height);
            widget.onUpdate(text, top, left, selectedColor, selectedFontSize, isBold, isItalic, selectedFont);
          });
        },
        child: Text(text, style: textStyle), // Display the text.
      ),
    );
  }
}


class DrawPoint {
  Offset offset;
  Color color;
  DrawPoint(this.offset, this.color);
}

class VisitingCardScreen extends StatefulWidget {
  @override
  State<VisitingCardScreen> createState() => _VisitingCardScreenState();
}

class _VisitingCardScreenState extends State<VisitingCardScreen> {
  File? profileImage; // Stores the selected profile image file.
  Offset profileOffset = const Offset(270, 10); // Initial position for the profile image.

  File? backgroundImage; // Stores the selected background image file.
  final double cardWidth = 350; // Fixed width of the visiting card.
  final double cardHeight = 200; // Fixed height of the visiting card.
  final picker = ImagePicker(); // ImagePicker instance for picking images.
  List<Map<String, dynamic>> textFields = []; // List to hold properties of all editable text fields.
  List<DrawPoint> points = []; // List to hold points for freehand drawing.
  int nextId = 0; // Counter for unique IDs for text fields.
  int rgbState = 0; // State for cycling through drawing colors.

  // Adds a new editable text field to the card.
  void addTextField() {
    setState(() {
      textFields.add({
        "id": nextId++,
        "text": "New Field",
        "top": 60.0,
        "left": 40.0,
        "color": Colors.black,
        "size": 16.0,
        "bold": false,
        "italic": false,
        "font": 'Roboto',
      });
    });
  }


  void clearDrawing() => setState(() => points.clear());

  // Allows user to pick a background image from gallery.
  Future<void> pickBackgroundImage() async {
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() => backgroundImage = File(picked.path));
    }
  }

  // Allows user to pick a profile image from gallery.
  Future<void> pickProfileImage() async {
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() => profileImage = File(picked.path));
    }
  }

  Color getNextColor() {
    rgbState = (rgbState + 1) % 3;
    return [Colors.red, Colors.green, Colors.blue][rgbState];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Visiting Card PRO"),
        actions: [
          // Button to pick background image.
          IconButton(icon: const Icon(Icons.image), onPressed: pickBackgroundImage, tooltip: "Set Background Image"),

          // Button to remove profile image (only visible if an image is set).
          if (profileImage != null)
            IconButton(
              icon: const Icon(Icons.person_remove),
              onPressed: () {
                setState(() {
                  profileImage = null; // Set profileImage to null to remove it
                });
              },
              tooltip: "Remove Profile Image",
            ),
        ],
      ),
      body: Center(
        child: Container(
          width: cardWidth,
          height: cardHeight,
          margin: const EdgeInsets.all(20), // Margin around the card.
          child: Stack(
            children: [
              Container(
                width: cardWidth,
                height: cardHeight,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16), // Rounded corners.
                  image: backgroundImage != null
                      ? DecorationImage(image: FileImage(backgroundImage!), fit: BoxFit.cover)
                      : null, // Display background image if available.
                  gradient: backgroundImage == null
                      ? const LinearGradient(colors: [Colors.purple, Colors.orange, Colors.blue])
                      : null, // Fallback gradient if no image.
                ),
              ),
              GestureDetector(
                onPanDown: (details) {
                  final RenderBox box = context.findRenderObject() as RenderBox;
                  final local = box.globalToLocal(details.globalPosition);

                  final Offset cardLocalOffset = Offset(
                    local.dx - ((MediaQuery.of(context).size.width - cardWidth) / 2), // Adjust for horizontal centering.

                    local.dy - (MediaQuery.of(context).padding.top + AppBar().preferredSize.height + 20), // Adjust for app bar and margin.
                  );


                  if (cardLocalOffset.dx >= 0 && cardLocalOffset.dx <= cardWidth && cardLocalOffset.dy >= 0 && cardLocalOffset.dy <= cardHeight) {
                    setState(() => points.add(DrawPoint(cardLocalOffset, getNextColor())));
                  }
                },
                onPanUpdate: (details) {

                  final RenderBox box = context.findRenderObject() as RenderBox;
                  final local = box.globalToLocal(details.globalPosition);
                  final Offset cardLocalOffset = Offset(
                    local.dx - ((MediaQuery.of(context).size.width - cardWidth) / 2),
                    (local.dy - (MediaQuery.of(context).padding.top + AppBar().preferredSize.height + 20)), // Dynamic calculation
                  );
                  if (cardLocalOffset.dx >= 0 && cardLocalOffset.dx <= cardWidth && cardLocalOffset.dy >= 0 && cardLocalOffset.dy <= cardHeight) {
                    setState(() => points.add(DrawPoint(cardLocalOffset, getNextColor())));
                  }
                },
                child: CustomPaint(size: Size(cardWidth, cardHeight), painter: _DrawingPainter(points)),
              ),
              // Profile image widget, if available.
              if (profileImage != null)
                Positioned(
                  top: profileOffset.dy,
                  left: profileOffset.dx,
                  child: GestureDetector(
                    onPanUpdate: (details) {
                      // Allow dragging the profile image.
                      setState(() {
                        final newX = (profileOffset.dx + details.delta.dx).clamp(0.0, cardWidth - 60); // Clamp within card width.
                        final newY = (profileOffset.dy + details.delta.dy).clamp(0.0, cardHeight - 60); // Clamp within card height.
                        profileOffset = Offset(newX, newY);
                      });
                    },
                    onTap: pickProfileImage, // Tap to re-pick image.
                    child: CircleAvatar(
                      radius: 30,
                      backgroundImage: FileImage(profileImage!),
                    ),
                  ),
                ),

              ...textFields.map((field) {
                return EditableDraggableText(
                  key: ValueKey(field["id"]), // Unique key for each text field.
                  text: field["text"] as String,
                  initialTop: (field["top"] as double),
                  initialLeft: (field["left"] as double),
                  initialColor: (field["color"] as Color),
                  initialFontSize: (field["size"] as double),
                  initialBold: (field["bold"] as bool),
                  initialItalic: (field["italic"] as bool),
                  initialFont: (field["font"] as String),
                  cardWidth: cardWidth,
                  cardHeight: cardHeight,

                  onDelete: () => setState(() => textFields.removeWhere((f) => f["id"] == field["id"])),

                  onUpdate: (text, top, left, color, size, bold, italic, font) {
                    setState(() {
                      field["text"] = text;
                      field["top"] = top;
                      field["left"] = left;
                      field["color"] = color;
                      field["size"] = size;
                      field["bold"] = bold;
                      field["italic"] = italic;
                      field["font"] = font;
                    });
                  },
                );
              }),
            ],
          ),
        ),
      ),

      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: pickProfileImage,
            tooltip: "Add/Change Profile",
            heroTag: "profile_image_btn", // Unique tag for hero animation.
            child: const Icon(Icons.person),
          ),
          const SizedBox(width: 15),
          FloatingActionButton(
            onPressed: addTextField,
            tooltip: "Add Text",
            heroTag: "add_text_btn", // Unique tag for hero animation.
            child: const Icon(Icons.text_fields),
          ),
        ],
      ),
    );
  }
}

class _DrawingPainter extends CustomPainter {
  final List<DrawPoint> points; // List of points to draw.
  _DrawingPainter(this.points);

  @override
  void paint(Canvas canvas, Size size) {

    final paint = Paint()
      ..style = PaintingStyle.fill; // Ensure circles are filled.


    for (var p in points) {
      paint.color = p.color; // Set color for each point.
      canvas.drawCircle(p.offset, 2.0, paint); // Draw a small, distinct circle.
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true; // Always repaint to show drawing updates.
}
