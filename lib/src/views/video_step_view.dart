import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:survey_kit/src/controller/survey_controller.dart';
import 'package:survey_kit/src/result/question_result.dart';
import 'package:survey_kit/src/result/step/video_step_result.dart';
import 'package:survey_kit/src/steps/predefined_steps/video_step.dart';
import 'package:survey_kit/src/views/widget/step_view.dart';
import 'package:video_player/video_player.dart';
import 'package:provider/provider.dart';

class VideoStepView extends StatefulWidget {
  final QuestionResult? questionResult;
  final VideoStep videoStep;

  const VideoStepView({
    Key? key,
    required this.videoStep,
    this.questionResult,
  }) : super(key: key);

  @override
  _VideoStepViewState createState() => _VideoStepViewState();
}

class _VideoStepViewState extends State<VideoStepView> {
  final DateTime _startDate = DateTime.now();

  VideoPlayerController? _videoPlayerController;
  ChewieController? _chewieController;

  @override
  void initState() {
    super.initState();
    _initPlayer();
  }

  void _initPlayer() async {
    final videoStep = widget.videoStep;

    _videoPlayerController =
        VideoPlayerController.networkUrl(Uri.parse(widget.videoStep.url));
    await _videoPlayerController?.initialize();
    setState(() {
      _chewieController = ChewieController(
        videoPlayerController: _videoPlayerController!,
        autoPlay: videoStep.isAutoPlay,
        looping: videoStep.isLooping,
        fullScreenByDefault: videoStep.isAutomaticFullscreen,
        allowMuting: videoStep.allowMuting,
      );

      //It should go automaticly to the next step after the video is finished
      if (videoStep.goToNextPageAfterEnd || videoStep.requirePlaythrough)
        _videoPlayerController!.addListener(_videoHasEndedListener);
    });
  }

  bool get isVideoEnd =>
      _videoPlayerController!.value.position ==
      _videoPlayerController!.value.duration;

  void _videoHasEndedListener() {
    if (isVideoEnd) {
      final surveyController = context.read<SurveyController>();

      _chewieController?.exitFullScreen();
      if (widget.videoStep.requirePlaythrough) setState(() {});
      if (!widget.videoStep.goToNextPageAfterEnd) return;

      final end = DateTime.now();
      final videoResult = VideoResult(
          leftVideoAt:
              Duration(milliseconds: end.millisecond - _startDate.millisecond),
          stayedInVideo: end);
      WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {
            surveyController.nextStep(
              context,
              () {
                return VideoStepResult(
                  id: widget.videoStep.stepIdentifier,
                  startDate: _startDate,
                  endDate: DateTime.now(),
                  result: videoResult,
                );
              },
            );
          }));
    }
  }

  @override
  void dispose() {
    _videoPlayerController?.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_videoPlayerController?.value.isInitialized != true)
      return Center(child: CircularProgressIndicator());

    if (widget.videoStep.isAutomaticFullscreen &&
        !(_chewieController?.isFullScreen ?? false)) {
      _chewieController?.enterFullScreen();
    }
    return StepView(
      resultFunction: () {
        final end = DateTime.now();
        final videoResult = VideoResult(
          leftVideoAt:
              Duration(milliseconds: end.millisecond - _startDate.millisecond),
          stayedInVideo: end,
        );

        return VideoStepResult(
          id: widget.videoStep.stepIdentifier,
          startDate: _startDate,
          endDate: DateTime.now(),
          result: videoResult,
        );
      },
      isValid: !widget.videoStep.requirePlaythrough || isVideoEnd,
      step: widget.videoStep,
      title: SizedBox.shrink(),
      child: Container(
        alignment: Alignment.center,
        width: widget.videoStep.width ?? MediaQuery.of(context).size.width,
        height: widget.videoStep.height ?? MediaQuery.of(context).size.width,
        child: Chewie(
          controller: _chewieController!,
        ),
      ),
    );
  }
}
