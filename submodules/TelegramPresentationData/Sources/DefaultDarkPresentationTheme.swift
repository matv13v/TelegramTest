import Foundation
import UIKit

private func makeDarkPresentationTheme(accentColor: UIColor) -> PresentationTheme {
    let destructiveColor: UIColor = UIColor(rgb: 0xeb5545)
    let constructiveColor: UIColor = UIColor(rgb: 0x08a723)
    let secretColor: UIColor = UIColor(rgb: 0x00B12C)

    let rootTabBar = PresentationThemeRootTabBar(
        backgroundColor: UIColor(rgb: 0x1c1c1d),
        separatorColor: UIColor(rgb: 0x3d3d40),
        iconColor: UIColor(rgb: 0x828282),
        selectedIconColor: accentColor,
        textColor: UIColor(rgb: 0x828282),
        selectedTextColor: accentColor,
        badgeBackgroundColor: UIColor(rgb: 0xeb5545),
        badgeStrokeColor: UIColor(rgb: 0x1c1c1d),
        badgeTextColor: UIColor(rgb: 0xffffff)
    )

    let rootNavigationBar = PresentationThemeRootNavigationBar(
        buttonColor: accentColor,
        disabledButtonColor: UIColor(rgb: 0x525252),
        primaryTextColor: .white,
        secondaryTextColor: UIColor(rgb: 0xffffff, alpha: 0.5),
        controlColor: UIColor(rgb: 0x767676),
        accentTextColor: accentColor,
        backgroundColor: UIColor(rgb: 0x1c1c1d),
        separatorColor: UIColor(rgb: 0x3d3d40),
        badgeBackgroundColor: UIColor(rgb: 0xeb5545),
        badgeStrokeColor: UIColor(rgb: 0x1c1c1d),
        badgeTextColor: UIColor(rgb: 0xffffff)
    )

    let navigationSearchBar = PresentationThemeNavigationSearchBar(
        backgroundColor: UIColor(rgb: 0x1c1c1d),
        accentColor: accentColor,
        inputFillColor: UIColor(rgb: 0x0f0f0f),
        inputTextColor: accentColor,
        inputPlaceholderTextColor: UIColor(rgb: 0x8f8f8f),
        inputIconColor: UIColor(rgb: 0x8f8f8f),
        inputClearButtonColor: UIColor(rgb: 0x8f8f8f),
        separatorColor: UIColor(rgb: 0x3d3d40)
    )

    let auth = PresentationThemeAuth(
        introStartButtonColor: accentColor,
        introDotColor: UIColor(rgb: 0x5e5e5e)
    )

    let passcode = PresentationThemePasscode(
        backgroundColors: PresentationThemeGradientColors(topColor: UIColor(rgb: 0x000000), bottomColor: UIColor(rgb: 0x000000)),
        buttonColor: UIColor(rgb: 0x1c1c1d)
    )

    let rootController = PresentationThemeRootController(
        statusBarStyle: .white,
        tabBar: rootTabBar,
        navigationBar: rootNavigationBar,
        navigationSearchBar: navigationSearchBar
    )

    let switchColors = PresentationThemeSwitch(
        frameColor: UIColor(rgb: 0x5a5a5e),
        handleColor: UIColor(rgb: 0x121212),
        contentColor: UIColor(rgb: 0xb2b2b2),
        positiveColor: UIColor(rgb: 0x000000),
        negativeColor: destructiveColor
    )

    let list = PresentationThemeList(
        blocksBackgroundColor: UIColor(rgb: 0x000000),
        plainBackgroundColor: UIColor(rgb: 0x000000),
        itemPrimaryTextColor: UIColor(rgb: 0xffffff),
        itemSecondaryTextColor: UIColor(rgb: 0x8f8f8f),
        itemDisabledTextColor: UIColor(rgb: 0x4d4d4d),
        itemAccentColor: accentColor,
        itemHighlightedColor: UIColor(rgb: 0x28b772),
        itemDestructiveColor: destructiveColor,
        itemPlaceholderTextColor: UIColor(rgb: 0x4d4d4d),
        itemBlocksBackgroundColor: UIColor(rgb: 0x1c1c1d),
        itemHighlightedBackgroundColor: UIColor(rgb: 0x313135),
        itemBlocksSeparatorColor: UIColor(rgb: 0x3d3d40),
        itemPlainSeparatorColor: UIColor(rgb: 0x3d3d40),
        disclosureArrowColor: UIColor(rgb: 0x5a5a5e),
        sectionHeaderTextColor: UIColor(rgb: 0xffffff),
        freeTextColor: UIColor(rgb: 0x8d8e93),
        freeTextErrorColor: UIColor(rgb: 0xcf3030),
        freeTextSuccessColor: UIColor(rgb: 0x30cf30),
        freeMonoIconColor: UIColor(rgb: 0x8d8e93),
        itemSwitchColors: switchColors,
        itemDisclosureActions: PresentationThemeItemDisclosureActions(
            neutral1: PresentationThemeFillForeground(fillColor: UIColor(rgb: 0x666666), foregroundColor: .white),
            neutral2: PresentationThemeFillForeground(fillColor: UIColor(rgb: 0xcd7800), foregroundColor: .white),
            destructive: PresentationThemeFillForeground(fillColor: UIColor(rgb: 0xc70c0c), foregroundColor: .white),
            constructive: PresentationThemeFillForeground(fillColor: constructiveColor, foregroundColor: .white),
            accent: PresentationThemeFillForeground(fillColor: UIColor(rgb: 0x666666), foregroundColor: .white),
            warning: PresentationThemeFillForeground(fillColor: UIColor(rgb: 0xcd7800), foregroundColor: .white),
            inactive: PresentationThemeFillForeground(fillColor: UIColor(rgb: 0x666666), foregroundColor: .white)
        ),
        itemCheckColors: PresentationThemeFillStrokeForeground(
            fillColor: accentColor,
            strokeColor: UIColor(rgb: 0xffffff, alpha: 0.5),
            foregroundColor: UIColor(rgb: 0x000000)
        ),
        controlSecondaryColor: UIColor(rgb: 0xffffff, alpha: 0.5),
        freeInputField: PresentationInputFieldTheme(
            backgroundColor: UIColor(rgb: 0xffffff, alpha: 0.5),
            placeholderColor: UIColor(rgb: 0x4d4d4d),
            primaryColor: .white,
            controlColor: UIColor(rgb: 0x4d4d4d)
        ),
        mediaPlaceholderColor: UIColor(rgb: 0x1c1c1d),
        scrollIndicatorColor: UIColor(white: 1.0, alpha: 0.3),
        pageIndicatorInactiveColor: UIColor(white: 1.0, alpha: 0.3),
        inputClearButtonColor: UIColor(rgb: 0x8B9197)
    )

    let chatList = PresentationThemeChatList(
        backgroundColor: UIColor(rgb: 0x000000),
        itemSeparatorColor: UIColor(rgb: 0x3d3d40),
        itemBackgroundColor: UIColor(rgb: 0x000000),
        pinnedItemBackgroundColor: UIColor(rgb: 0x1c1c1d),
        itemHighlightedBackgroundColor: UIColor(rgb: 0x191919),
        itemSelectedBackgroundColor: UIColor(rgb: 0x191919),
        titleColor: UIColor(rgb: 0xffffff),
        secretTitleColor: secretColor,
        dateTextColor: UIColor(rgb: 0x8e8e92),
        authorNameColor: UIColor(rgb: 0xffffff),
        messageTextColor: UIColor(rgb: 0x8e8e92),
        messageDraftTextColor: UIColor(rgb: 0xdd4b39),
        checkmarkColor: accentColor,
        pendingIndicatorColor: UIColor(rgb: 0xffffff),
        failedFillColor: destructiveColor,
        failedForegroundColor: .white,
        muteIconColor: UIColor(rgb: 0x8e8e92),
        unreadBadgeActiveBackgroundColor: UIColor(rgb: 0xffffff),
        unreadBadgeActiveTextColor: UIColor(rgb: 0x000000),
        unreadBadgeInactiveBackgroundColor: UIColor(rgb: 0x666666),
        unreadBadgeInactiveTextColor:UIColor(rgb: 0x000000),
        pinnedBadgeColor: UIColor(rgb: 0x767677),
        pinnedSearchBarColor: UIColor(rgb: 0x272728),
        regularSearchBarColor: UIColor(rgb: 0x272728),
        sectionHeaderFillColor: UIColor(rgb: 0x1C1C1D),
        sectionHeaderTextColor: UIColor(rgb: 0xffffff),
        searchBarKeyboardColor: .dark,
        verifiedIconFillColor: accentColor,
        verifiedIconForegroundColor: .white,
        secretIconColor: secretColor,
        pinnedArchiveAvatarColor: PresentationThemeArchiveAvatarColors(backgroundColors: PresentationThemeGradientColors(topColor: UIColor(rgb: 0x72d5fd), bottomColor: UIColor(rgb: 0x2a9ef1)), foregroundColor: .white),
        unpinnedArchiveAvatarColor: PresentationThemeArchiveAvatarColors(backgroundColors: PresentationThemeGradientColors(topColor: UIColor(rgb: 0x666666), bottomColor: UIColor(rgb: 0x666666)), foregroundColor: .black),
        onlineDotColor: UIColor(rgb: 0x4cc91f)
    )
    
    let message = PresentationThemeChatMessage(
        incoming: PresentationThemePartedColors(bubble: PresentationThemeBubbleColor(withWallpaper: PresentationThemeBubbleColorComponents(fill: UIColor(rgb: 0x262628), highlightedFill: UIColor(rgb: 0x353539), stroke: UIColor(rgb: 0x262628)), withoutWallpaper: PresentationThemeBubbleColorComponents(fill: UIColor(rgb: 0x262628), highlightedFill: UIColor(rgb: 0x353539), stroke: UIColor(rgb: 0x262628))), primaryTextColor: .white, secondaryTextColor: UIColor(rgb: 0xffffff, alpha: 0.5), linkTextColor: accentColor, linkHighlightColor: accentColor.withAlphaComponent(0.5), scamColor: destructiveColor, textHighlightColor: UIColor(rgb: 0xffe438), accentTextColor: .white, accentControlColor: .white, mediaActiveControlColor: UIColor(rgb: 0xffffff, alpha: 0.6), mediaInactiveControlColor: UIColor(rgb: 0xffffff, alpha: 0.3), pendingActivityColor: UIColor(rgb: 0xffffff, alpha: 0.5), fileTitleColor: .white, fileDescriptionColor: UIColor(rgb: 0xffffff, alpha: 0.5), fileDurationColor: UIColor(rgb: 0xffffff, alpha: 0.5), mediaPlaceholderColor: UIColor(rgb: 0x1f1f1f).mixedWith(.white, alpha: 0.05), polls: PresentationThemeChatBubblePolls(radioButton: UIColor(rgb: 0x737373), radioProgress: accentColor, highlight: accentColor.withAlphaComponent(0.12), separator: UIColor(rgb: 0x000000), bar: accentColor), actionButtonsFillColor: PresentationThemeVariableColor(withWallpaper: UIColor(rgb: 0x000000, alpha: 0.5), withoutWallpaper: UIColor(rgb: 0x000000, alpha: 0.5)), actionButtonsStrokeColor: PresentationThemeVariableColor(color: UIColor(rgb: 0xb2b2b2, alpha: 0.18)), actionButtonsTextColor: PresentationThemeVariableColor(color: UIColor(rgb: 0xffffff))),
        outgoing: PresentationThemePartedColors(bubble: PresentationThemeBubbleColor(withWallpaper: PresentationThemeBubbleColorComponents(fill: accentColor, highlightedFill: accentColor.withMultipliedBrightnessBy(1.421), stroke: accentColor), withoutWallpaper: PresentationThemeBubbleColorComponents(fill: accentColor, highlightedFill: accentColor.withMultipliedBrightnessBy(1.421), stroke: accentColor)), primaryTextColor: .white, secondaryTextColor: UIColor(rgb: 0xffffff, alpha: 0.5), linkTextColor: .white, linkHighlightColor: UIColor.white.withAlphaComponent(0.5), scamColor: destructiveColor, textHighlightColor: UIColor(rgb: 0xffe438), accentTextColor: .white, accentControlColor: .white, mediaActiveControlColor: .white, mediaInactiveControlColor: UIColor(rgb: 0xffffff, alpha: 0.3), pendingActivityColor: UIColor(rgb: 0xffffff, alpha: 0.5), fileTitleColor: .white, fileDescriptionColor: UIColor(rgb: 0xffffff, alpha: 0.5), fileDurationColor: UIColor(rgb: 0xffffff, alpha: 0.5), mediaPlaceholderColor: UIColor(rgb: 0x313131).mixedWith(.white, alpha: 0.05), polls: PresentationThemeChatBubblePolls(radioButton: UIColor(rgb: 0x838383), radioProgress: accentColor, highlight: accentColor.withAlphaComponent(0.12), separator: UIColor(white: 0.3, alpha: 1.0), bar: accentColor), actionButtonsFillColor: PresentationThemeVariableColor(withWallpaper: UIColor(rgb: 0x000000, alpha: 0.5), withoutWallpaper: UIColor(rgb: 0x000000, alpha: 0.5)), actionButtonsStrokeColor: PresentationThemeVariableColor(color: UIColor(rgb: 0xb2b2b2, alpha: 0.18)), actionButtonsTextColor: PresentationThemeVariableColor(color: UIColor(rgb: 0xffffff))),
        freeform: PresentationThemeBubbleColor(withWallpaper: PresentationThemeBubbleColorComponents(fill: UIColor(rgb: 0x1f1f1f), highlightedFill: UIColor(rgb: 0x2a2a2a), stroke: UIColor(rgb: 0x1f1f1f)), withoutWallpaper: PresentationThemeBubbleColorComponents(fill: UIColor(rgb: 0x1f1f1f), highlightedFill: UIColor(rgb: 0x2a2a2a), stroke: UIColor(rgb: 0x1f1f1f))),
        infoPrimaryTextColor: .white,
        infoLinkTextColor: accentColor,
        outgoingCheckColor: .white,
        mediaDateAndStatusFillColor: UIColor(white: 0.0, alpha: 0.5),
        mediaDateAndStatusTextColor: .white,
        shareButtonFillColor: PresentationThemeVariableColor(withWallpaper: UIColor(rgb: 0x000000, alpha: 0.5), withoutWallpaper: UIColor(rgb: 0x000000, alpha: 0.5)),
        shareButtonStrokeColor: PresentationThemeVariableColor(withWallpaper: UIColor(rgb: 0xb2b2b2, alpha: 0.18), withoutWallpaper: UIColor(rgb: 0xb2b2b2, alpha: 0.18)),
        shareButtonForegroundColor: PresentationThemeVariableColor(withWallpaper: UIColor(rgb: 0xb2b2b2), withoutWallpaper: UIColor(rgb: 0xb2b2b2)),
        mediaOverlayControlColors: PresentationThemeFillForeground(fillColor: UIColor(rgb: 0x000000, alpha: 0.6), foregroundColor: .white),
        selectionControlColors: PresentationThemeFillStrokeForeground(fillColor: accentColor, strokeColor: .white, foregroundColor: .white),
        deliveryFailedColors: PresentationThemeFillForeground(fillColor: destructiveColor, foregroundColor: .white),
        mediaHighlightOverlayColor: UIColor(white: 1.0, alpha: 0.6)
    )
    
    let serviceMessage = PresentationThemeServiceMessage(
        components: PresentationThemeServiceMessageColor(withDefaultWallpaper: PresentationThemeServiceMessageColorComponents(fill: UIColor(rgb: 0x1f1f1f, alpha: 1.0), primaryText: UIColor(rgb: 0xffffff), linkHighlight: UIColor(rgb: 0xffffff, alpha: 0.12), scam: destructiveColor, dateFillStatic: UIColor(rgb: 0x1f1f1f, alpha: 1.0), dateFillFloating: UIColor(rgb: 0xffffff, alpha: 0.2)), withCustomWallpaper: PresentationThemeServiceMessageColorComponents(fill: UIColor(rgb: 0x1f1f1f, alpha: 1.0), primaryText: .white, linkHighlight: UIColor(rgb: 0xffffff, alpha: 0.12), scam: destructiveColor, dateFillStatic: UIColor(rgb: 0x1f1f1f, alpha: 1.0), dateFillFloating: UIColor(rgb: 0xffffff, alpha: 0.2))),
        unreadBarFillColor: UIColor(rgb: 0x1b1b1b),
        unreadBarStrokeColor: UIColor(rgb: 0x000000),
        unreadBarTextColor: UIColor(rgb: 0xb2b2b2),
        dateTextColor: PresentationThemeVariableColor(color: UIColor(rgb: 0xffffff))
    )

    let inputPanelMediaRecordingControl = PresentationThemeChatInputPanelMediaRecordingControl(
        buttonColor: accentColor,
        micLevelColor: accentColor.withAlphaComponent(0.2),
        activeIconColor: .black,
        panelControlFillColor: UIColor(rgb: 0x1C1C1D),
        panelControlStrokeColor: UIColor(rgb: 0x1C1C1D),
        panelControlContentPrimaryColor: UIColor(rgb: 0x9597a0),
        panelControlContentAccentColor: accentColor
    )

    let inputPanel = PresentationThemeChatInputPanel(
        panelBackgroundColor: UIColor(rgb: 0x1c1c1d),
        panelStrokeColor: UIColor(rgb: 0x000000),
        panelControlAccentColor: accentColor,
        panelControlColor: UIColor(rgb: 0x808080),
        panelControlDisabledColor: UIColor(rgb: 0x808080, alpha: 0.5),
        panelControlDestructiveColor: UIColor(rgb: 0xff3b30),
        inputBackgroundColor: UIColor(rgb: 0x060606),
        inputStrokeColor: UIColor(rgb: 0x060606),
        inputPlaceholderColor: UIColor(rgb: 0x7b7b7b),
        inputTextColor: UIColor(rgb: 0xffffff),
        inputControlColor: UIColor(rgb: 0x7b7b7b),
        actionControlFillColor: accentColor,
        actionControlForegroundColor: .white,
        primaryTextColor: UIColor(rgb: 0xffffff),
        secondaryTextColor: UIColor(rgb: 0xffffff, alpha: 0.5),
        mediaRecordingDotColor: .white,
        keyboardColor: .dark,
        mediaRecordingControl: inputPanelMediaRecordingControl
    )

    let inputMediaPanel = PresentationThemeInputMediaPanel(
        panelSeparatorColor: UIColor(rgb: 0x3d3d40),
        panelIconColor: UIColor(rgb: 0x808080),
        panelHighlightedIconBackgroundColor: UIColor(rgb: 0x000000),
        stickersBackgroundColor: UIColor(rgb: 0x000000),
        stickersSectionTextColor: UIColor(rgb: 0x7b7b7b),
        stickersSearchBackgroundColor: UIColor(rgb: 0x1c1c1d),
        stickersSearchPlaceholderColor: UIColor(rgb: 0x8e8e92),
        stickersSearchPrimaryColor: .white,
        stickersSearchControlColor: UIColor(rgb: 0x8e8e92),
        gifsBackgroundColor: UIColor(rgb: 0x000000)
    )

    let inputButtonPanel = PresentationThemeInputButtonPanel(
        panelSeparatorColor: UIColor(rgb: 0x3d3d40),
        panelBackgroundColor: UIColor(rgb: 0x141414),
        buttonFillColor: UIColor(rgb: 0x5A5A5A),
        buttonStrokeColor: UIColor(rgb: 0x0C0C0C),
        buttonHighlightedFillColor: UIColor(rgb: 0x5A5A5A, alpha: 0.7),
        buttonHighlightedStrokeColor: UIColor(rgb: 0x0C0C0C),
        buttonTextColor: UIColor(rgb: 0xffffff)
    )

    let historyNavigation = PresentationThemeChatHistoryNavigation(
        fillColor: UIColor(rgb: 0x1C1C1D),
        strokeColor: UIColor(rgb: 0x000000),
        foregroundColor: UIColor(rgb: 0xffffff),
        badgeBackgroundColor: accentColor,
        badgeStrokeColor: .black,
        badgeTextColor: .black
    )

    let chat = PresentationThemeChat(
        message: message,
        serviceMessage: serviceMessage,
        inputPanel: inputPanel,
        inputMediaPanel: inputMediaPanel,
        inputButtonPanel: inputButtonPanel,
        historyNavigation: historyNavigation
    )

    let actionSheet = PresentationThemeActionSheet(
        dimColor: UIColor(white: 0.0, alpha: 0.5),
        backgroundType: .dark,
        opaqueItemBackgroundColor: UIColor(rgb: 0x1c1c1d),
        itemBackgroundColor: UIColor(rgb: 0x1c1c1d, alpha: 0.8),
        opaqueItemHighlightedBackgroundColor: UIColor(white: 0.0, alpha: 1.0),
        itemHighlightedBackgroundColor: UIColor(rgb: 0x000000, alpha: 0.5),
        opaqueItemSeparatorColor: UIColor(rgb: 0x3d3d40),
        standardActionTextColor: accentColor,
        destructiveActionTextColor: destructiveColor,
        disabledActionTextColor: UIColor(rgb: 0x4d4d4d),
        primaryTextColor: .white,
        secondaryTextColor: UIColor(rgb: 0x5e5e5e),
        controlAccentColor: accentColor,
        inputBackgroundColor: UIColor(rgb: 0x5a5a5e),
        inputHollowBackgroundColor: UIColor(rgb: 0x5a5a5e),
        inputBorderColor: UIColor(rgb: 0x5a5a5e),
        inputPlaceholderColor: UIColor(rgb: 0xaaaaaa),
        inputTextColor: .white,
        inputClearButtonColor: UIColor(rgb: 0xaaaaaa),
        checkContentColor: .black
    )

    let inAppNotification = PresentationThemeInAppNotification(
        fillColor: UIColor(rgb: 0x1c1c1d),
        primaryTextColor: .white,
        expandedNotification: PresentationThemeExpandedNotification(
            backgroundType: .dark,
            navigationBar: PresentationThemeExpandedNotificationNavigationBar(
                backgroundColor: UIColor(rgb: 0x1c1c1d),
                primaryTextColor: accentColor,
                controlColor: accentColor,
                separatorColor: UIColor(rgb: 0x000000)
            )
        )
    )

    return PresentationTheme(
        name: .builtin(.nightGrayscale),
        author: nil,
        overallDarkAppearance: true,
        auth: auth,
        passcode: passcode,
        rootController: rootController,
        list: list,
        chatList: chatList,
        chat: chat,
        actionSheet: actionSheet,
        inAppNotification: inAppNotification
    )
}

public let defaultDarkPresentationTheme = makeDarkPresentationTheme(accentColor: 0x2EA6FF)

public func makeDarkPresentationTheme(accentColor: Int32?) -> PresentationTheme {
    let color: UIColor
    if let accentColor = accentColor {
        color = UIColor(rgb: UInt32(bitPattern: accentColor))
    } else {
        color = UIColor(rgb: UInt32(bitPattern: defaultDayAccentColor))
    }
    return makeDarkPresentationTheme(accentColor: color)
}

