///
/// [Author] Alex (https://github.com/AlexV525)
/// [Date] 2022/2/14 13:25
///
import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:wechat_assets_picker/src/delegates/asset_picker_text_delegate.dart';

import '../delegates/asset_picker_builder_delegate.dart';
import '../delegates/sort_path_delegate.dart';
import 'constants.dart';
import 'enums.dart';

class AssetPickerConfig {
  const AssetPickerConfig({
    this.selectedAssets,
    this.maxAssets = 9,
    this.pageSize = 80,
    this.gridThumbSize = defaultAssetGridPreviewSize,
    this.previewThumbSize,
    this.specialPickerType,
    this.keepScrollOffset = false,
    this.pathThumbSize = 80,
    this.requestType = RequestType.common,
    this.sortPathDelegate,
    this.filterOptions,
    this.gridCount = 4,
    this.themeColor,
    this.pickerTheme,
    this.textDelegate,
    this.specialItemPosition = SpecialItemPosition.none,
    this.specialItemBuilder,
    this.loadingIndicatorBuilder,
    this.allowSpecialItemWhenEmpty = false,
    this.selectPredicate,
    this.shouldRevertGrid,
  })  : assert(maxAssets >= 1, 'maxAssets must be greater than 1.'),
        assert(
          pickerTheme == null || themeColor == null,
          'pickerTheme and themeColor cannot be set at the same time.',
        ),
        assert(
          pageSize % gridCount == 0,
          'pageSize must be a multiple of gridCount.',
        ),
        assert(
          specialPickerType != SpecialPickerType.wechatMoment ||
              requestType == RequestType.common,
          'SpecialPickerType.wechatMoment and requestType '
          'cannot be set at the same time.',
        ),
        assert(
          (specialItemBuilder == null &&
                  identical(specialItemPosition, SpecialItemPosition.none)) ||
              (specialItemBuilder != null &&
                  !identical(specialItemPosition, SpecialItemPosition.none)),
          'Custom item did not set properly.',
        );

  /// Selected assets.
  /// 已选中的资源
  final List<AssetEntity>? selectedAssets;

  /// Maximum count for asset selection.
  /// 资源选择的最大数量
  final int maxAssets;

  /// Assets should be loaded per page.
  /// 资源选择的最大数量
  ///
  /// Use `null` to display all assets into a single grid.
  final int pageSize;

  /// Thumbnail size in the grid.
  /// 预览时网络的缩略图大小
  ///
  /// This only works on images and videos since other types does not have to
  /// request for the thumbnail data. The preview can speed up by reducing it.
  /// 该参数仅生效于图片和视频类型的资源，因为其他资源不需要请求缩略图数据。
  /// 预览图片的速度可以通过适当降低它的数值来提升。
  ///
  /// This cannot be `null` or a large value since you shouldn't use the
  /// original data for the grid.
  /// 该值不能为空或者非常大，因为在网格中使用原数据不是一个好的决定。
  final int gridThumbSize;

  /// Preview thumbnail size in the viewer.
  /// 预览时图片的缩略图大小
  ///
  /// This only works on images and videos since other types does not have to
  /// request for the thumbnail data. The preview can speed up by reducing it.
  /// 该参数仅生效于图片和视频类型的资源，因为其他资源不需要请求缩略图数据。
  /// 预览图片的速度可以通过适当降低它的数值来提升。
  ///
  /// Default is `null`, which will request the origin data.
  /// 默认为空，即读取原图。
  final List<int>? previewThumbSize;

  /// The current special picker type for the picker.
  /// 当前特殊选择类型
  ///
  /// Several types which are special:
  /// * [SpecialPickerType.wechatMoment] When user selected video, no more images
  /// can be selected.
  /// * [SpecialPickerType.noPreview] Disable preview of asset; Clicking on an
  /// asset selects it.
  ///
  /// 这里包含一些特殊选择类型：
  /// * [SpecialPickerType.wechatMoment] 微信朋友圈模式。当用户选择了视频，将不能选择图片。
  /// * [SpecialPickerType.noPreview] 禁用资源预览。多选时单击资产将直接选中，单选时选中并返回。
  final SpecialPickerType? specialPickerType;

  /// Whether the picker should save the scroll offset between pushes and pops.
  /// 选择器是否可以从同样的位置开始选择
  final bool keepScrollOffset;

  /// Thumb size for path selector.
  /// 路径选择器中缩略图的大小
  final int pathThumbSize;

  /// Request assets type.
  /// 请求的资源类型
  final RequestType requestType;

  /// Delegate to sort asset path entities.
  /// 资源路径排序的实现
  final SortPathDelegate<AssetPathEntity>? sortPathDelegate;

  /// Filter options for the picker.
  /// 选择器的筛选条件
  ///
  /// Will be merged into the base configuration.
  /// 将会与基础条件进行合并。
  final FilterOptionGroup? filterOptions;

  /// Assets count for the picker.
  /// 资源网格数
  final int gridCount;

  /// Main color for the picker.
  /// 选择器的主题色
  final Color? themeColor;

  /// Theme for the picker.
  /// 选择器的主题
  ///
  /// Usually the WeChat uses the dark version (dark background color)
  /// for the picker. However, some others want a light or a custom version.
  ///
  /// 通常情况下微信选择器使用的是暗色（暗色背景）的主题，
  /// 但某些情况下开发者需要亮色或自定义主题。
  final ThemeData? pickerTheme;

  final AssetPickerTextDelegate? textDelegate;

  /// Allow users set a special item in the picker with several positions.
  /// 允许用户在选择器中添加一个自定义item，并指定位置
  final SpecialItemPosition specialItemPosition;

  /// The widget builder for the the special item.
  /// 自定义item的构造方法
  final WidgetBuilder? specialItemBuilder;

  /// Indicates the loading status for the builder.
  /// 指示目前加载的状态
  final IndicatorBuilder? loadingIndicatorBuilder;

  /// Whether the special item will display or not when assets is empty.
  /// 当没有资源时是否显示自定义item
  final bool allowSpecialItemWhenEmpty;

  /// {@macro wechat_assets_picker.AssetSelectPredicate}
  final AssetSelectPredicate<AssetEntity>? selectPredicate;

  /// Whether the assets grid should revert.
  /// 判断资源网格是否需要倒序排列
  ///
  /// [Null] means judging by [isAppleOS].
  /// 使用 [Null] 即使用 [isAppleOS] 进行判断。
  final bool? shouldRevertGrid;
}
