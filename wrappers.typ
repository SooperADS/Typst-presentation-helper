#import "default.typ" as default

// Helpers

#let __value_or_default(value, default) = if value == auto { default } else { value }

#let __heading_color(base) = base.darken(20%)

#let __margin_color(base) = base.darken(40%).saturate(-30%)

// Wrappers

#let minimal-wrapper(document) = {
    set page(paper: "presentation-16-9", number-align: right)
    document
}

#let document-wrapper(
    page-bg: default.page-bg,
    page-margin: default.page-margin,
    font-size: default.font-size,
    document,
) = {
    set text(size: __value_or_default(font-size, default.font-size))
    set page(
        fill: __value_or_default(page-bg, default.page-bg),
        margin: __value_or_default(page-margin, default.page-margin),
    )

    document
}

#let heading-wrapper(
    header-font-size: default.header-font-size,
    header-above: default.header-above,
    header-below: default.header-below,
    base-color: default.base-color,
    heading,
) = align(center, block(
    below: __value_or_default(header-below, default.header-below),
    above: __value_or_default(header-above, default.header-above),
    text(
        heading,
        size: __value_or_default(
            header-font-size,
            default.header-font-size,
        ),
        fill: __heading_color(
            __value_or_default(base-color, default.base-color),
        ),
    ),
))

#let title-wrapper(
    title-font-size: default.title-font-size,
    title-color: default.title-color,
    title,
) = align(center + horizon, text(
    title,
    size: __value_or_default(
        title-font-size,
        default.header-font-size,
    ),
    fill: __heading_color(
        __value_or_default(title-color, default.base-color),
    ),
))

#let global-wrapper(
    base-color: default.base-color,
    title-color: default.title-color,
    header-above: default.header-above,
    header-below: default.header-below,
    page-bg: default.page-bg,
    font-size: default.font-size,
    header-font-size: default.header-font-size,
    title-font-size: default.title-font-size,
    page-margin: default.page-margin,
    document,
) = {
    show: minimal-wrapper
    show: document-wrapper.with(
        font-size: font-size,
        page-bg: page-bg,
        page-margin: page-margin,
    )

    show heading: heading-wrapper.with(
        base-color: base-color,
        header-above: header-above,
        header-below: header-below,
        header-font-size: header-font-size,
    )

    let true_header_font_size = __value_or_default(header-font-size, default.header-font-size)
    show heading: heading-wrapper.with(
        base-color: base-color,
        header-above: header-above,
        header-below: header-below,
        header-font-size: true_header_font_size,
    )

    show title: title-wrapper.with(
        title-color: title-color,
        title-font-size: __value_or_default(title-font-size, true_header_font_size),
    )

    document
}

#let page-presentation-watermark-wrapper(
    watermark-text-size: default.watermark-text-size,
    watermark-font: default.watermark-font,
    watermark-color: default.watermark-color,
    watermark-rotation: default.watermark-rotation,
    target-document,
) = {
    set page(
        foreground: rotate(
            __value_or_default(watermark-rotation, default.watermark-rotation),
            context text(
                document.title + "\n" + document.author.join(", "),
                size: __value_or_default(watermark-text-size, default.watermark-text-size),
                font: __value_or_default(watermark-font, default.watermark-font),
                fill: __value_or_default(watermark-color, default.watermark-color),
                weight: 900,
            ),
            origin: center + horizon,
        ),
    )

    target-document
}

#let page-presentation-no-fg-wrapper(document) = {
    set page(foreground: none)
    document
}

#let page-presentation-info-wrapper(
    margin-text-size: default.margin-text-size,
    margin-font: default.margin-font,
    margin-color: default.margin-color,
    page-margin: default.page-margin,
    numbering-color: default.numbering-color,
    numbering-text-size: default.numbering-text-size,
    show-author-label: true,
    show-title-label: true,
    show-numbering-label: true,
    target-document,
) = {
    let font_s = __value_or_default(margin-text-size, default.margin-text-size)
    let font_n = __value_or_default(margin-font, default.margin-font)
    let font_c = __margin_color(__value_or_default(margin-color, default.base-color))
    let pm = __value_or_default(page-margin, default.page-margin)

    let sw_al = __value_or_default(show-author-label, true)
    let sw_nl = __value_or_default(show-numbering-label, false)

    let footer_block = none
    if sw_al or sw_nl {
        footer_block = {
            if sw_al {
                place(left + bottom, dx: -pm, dy: -pm * 2, context text(
                    document.author.join(", "),
                    size: font_s,
                    font: font_n,
                    fill: font_c,
                ))
            }

            if sw_nl {
                place(right + bottom, dx: pm, dy: -pm * 2, context text(
                    counter(page).display(),
                    size: __value_or_default(numbering-text-size, default.numbering-text-size),
                    font: font_n,
                    fill: __margin_color(__value_or_default(numbering-color, default.numbering-color)),
                ))
            }
        }
    } else if show-numbering-label == false {
        footer_block = []
    }

    let header_block = none
    if __value_or_default(show-title-label, true) {
        header_block = place(top + right, dx: pm, dy: pm * 2, context text(
            document.title,
            size: font_s,
            font: font_n,
            fill: font_c,
        ))
    }

    set page(header: header_block, footer: footer_block, number-align: right, numbering: "1")
    target-document
}
