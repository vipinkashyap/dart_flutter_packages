library duo_rating_dialog;

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class RatingDialogResponse {
  /// The user's first rating
  double ratingOne;

  /// The user's second rating
  double ratingTwo;

  String get getRatingOneStatus {
    if (ratingOne == 1.0) {
      return 'Poor';
    } else if (ratingOne == 2.0) {
      return 'Below Average';
    } else if (ratingOne == 3.0) {
      return 'Average';
    } else if (ratingOne == 4.0) {
      return 'Above Average';
    } else if (ratingOne == 5.0) {
      return 'Excellent';
    } else {
      return '';
    }
  }

  String get getRatingTwoStatus {
    if (ratingTwo == 1.0) {
      return 'Poor';
    } else if (ratingTwo == 2.0) {
      return 'Below Average';
    } else if (ratingTwo == 3.0) {
      return 'Average';
    } else if (ratingTwo == 4.0) {
      return 'Above Average';
    } else if (ratingTwo == 5.0) {
      return 'Excellent';
    } else {
      return '';
    }
  }

  RatingDialogResponse({this.ratingOne = 0.0, this.ratingTwo = 0.0});
}

// ignore: must_be_immutable
class DuoRatingDialog extends StatefulWidget {
  /// The dialog's title
  final Text title;

  /// To add any Specific Logo/Icon
  final Icon ratingicon;

  /// The dialog's first message/description text
  final Text messageOne;

  /// The dialog's second message/description text
  final Text messageTwo;

  /// The rating bar (star icon & glow) color
  final Color starColor;

  /// The size of the star
  final double starSize;

  /// Disables the cancel button and forces the user to leave a rating
  final bool force;

  /// Show or hide the close button
  final bool showCloseButton;

  /// The initial first rating of the rating bar
  final double initialRatingOne;

  /// The initial second rating of the rating bar
  final double initialRatingTwo;

  /// The submit button's label/text
  final String submitButtonText;

  /// The submit button's label/text
  final TextStyle submitButtonTextStyle;

  /// Returns a RatingDialogResponse with user's rating and comment values
  final Function(RatingDialogResponse) onSubmitted;

  /// called when user cancels/closes the dialog
  final Function? onCancelled;

  const DuoRatingDialog(
      {super.key,
      required this.title,
      this.messageOne = const Text('Message One'),
      this.messageTwo = const Text('Message Two'),
      this.starColor = Colors.amber,
      this.starSize = 40,
      this.force = false,
      this.showCloseButton = true,
      this.initialRatingOne = 0.0,
      this.initialRatingTwo = 0.0,
      this.ratingicon = const Icon(
        Icons.flutter_dash,
        size: 70,
      ),
      required this.submitButtonText,
      required this.submitButtonTextStyle,
      required this.onSubmitted,
      this.onCancelled});

  @override
  State<DuoRatingDialog> createState() => _DuoRatingDialogState();
}

class _DuoRatingDialogState extends State<DuoRatingDialog> {
  RatingDialogResponse? _response;

  @override
  void initState() {
    super.initState();
    _response = RatingDialogResponse(
        ratingOne: widget.initialRatingOne, ratingTwo: widget.initialRatingTwo);
  }

  @override
  Widget build(BuildContext context) {
    final content = Stack(
      alignment: Alignment.topRight,
      children: <Widget>[
        ClipRRect(
          borderRadius: BorderRadius.circular(20.0),
          child: Padding(
              padding: const EdgeInsets.fromLTRB(25, 30, 25, 5),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  widget.ratingicon,
                  widget.title,
                  const SizedBox(
                    height: 15,
                  ),
                  //Question one
                  widget.messageOne,
                  const SizedBox(height: 10),
                  Center(
                    child: RatingBar.builder(
                      initialRating: widget.initialRatingOne,
                      glowColor: widget.starColor,
                      minRating: 0,
                      itemSize: widget.starSize,
                      direction: Axis.horizontal,
                      allowHalfRating: false,
                      itemCount: 5,
                      itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                      onRatingUpdate: (ratingOne) {
                        setState(() {
                          _response!.ratingOne = ratingOne;
                        });
                      },
                      itemBuilder: (context, _) => Icon(
                        Icons.star,
                        color: widget.starColor,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 5.0,
                  ),
                  Text(
                    _response!.getRatingOneStatus,
                    textScaler: const TextScaler.linear(.7),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  //Question Two
                  widget.messageTwo,
                  const SizedBox(height: 10),
                  Center(
                    child: RatingBar.builder(
                      initialRating: widget.initialRatingTwo,
                      glowColor: widget.starColor,
                      minRating: 0,
                      itemSize: widget.starSize,
                      direction: Axis.horizontal,
                      allowHalfRating: false,
                      itemCount: 5,
                      itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                      onRatingUpdate: (ratingTwo) {
                        setState(() {
                          _response!.ratingTwo = ratingTwo;
                        });
                      },
                      itemBuilder: (context, _) => Icon(
                        Icons.star,
                        color: widget.starColor,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 5.0,
                  ),
                  Text(
                    _response!.getRatingTwoStatus,
                    textScaler: const TextScaler.linear(.7),
                  ),
                  TextButton(
                    onPressed:
                        _response!.ratingOne == 0 || _response!.ratingTwo == 0
                            ? null
                            : () {
                                if (!widget.force) Navigator.pop(context);
                                widget.onSubmitted.call(_response!);
                              },
                    child: Text(
                      widget.submitButtonText,
                      style: widget.submitButtonTextStyle,
                    ),
                  ),

                  if (!widget.force &&
                      widget.onCancelled != null &&
                      widget.showCloseButton) ...[
                    IconButton(
                      icon: const Icon(Icons.close, size: 18),
                      onPressed: () {
                        Navigator.pop(context);
                        widget.onCancelled!.call();
                      },
                    )
                  ],
                ],
              )),
        )
      ],
    );
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      titlePadding: EdgeInsets.zero,
      scrollable: true,
      title: content,
    );
  }
}
