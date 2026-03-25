#import "default.typ" as default
#import "wrappers.typ": *

// Layout helpers

#let __slide(is-the-last-one: false, content) = {
    content
    if not is-the-last-one {
        pagebreak()
    }
}

#let __basic_slide(is-the-last-one: false, ..items) = __slide(
    align(center + horizon, block(width: 100%, height: 100%, {
        set align(horizon + left)
        items.pos().join()
    })),
    is-the-last-one: is-the-last-one,
)

#let __apply_show_rule(item, applicator, default-applicator: none) = {
    if type(applicator) == function {
        show: applicator
        item
    } else if applicator == auto and type(default-applicator) == function {
        show: default-applicator
        item
    } else {
        item
    }
}

// Slide functions

#let title-slide-wrapper = page-presentation-info-wrapper.with(
    show-author-label: false,
    show-numbering-label: false,
    show-title-label: false,
)

#let title-slide(
    title-page-bg: default.title-page-bg,
    title-color: default.title-color,
    is-the-last-one: false,
    show-applicator: auto,
    body: auto,
) = {
    set page(fill: __value_or_default(title-page-bg, default.title-page-bg), background: none)
    __apply_show_rule(
        __slide(text(title(body), fill: title-color), is-the-last-one: is-the-last-one),
        show-applicator,
        default-applicator: title-slide-wrapper,
    )
}

#let mono-slide(is-the-last-one: false, show-applicator: auto, body) = __apply_show_rule(
    __slide(body, is-the-last-one: is-the-last-one),
    show-applicator,
)

#let grid-slide(
    columns: auto,
    column-gutter: auto,
    rows: auto,
    row-gutter: auto,
    default-align: auto,
    fill: none,
    show-applicator: auto,
    header: none,
    is-the-last-one: false,
    ..body,
) = __apply_show_rule(
    __basic_slide(is-the-last-one: is-the-last-one, header, grid(
        columns: columns,
        column-gutter: column-gutter,
        rows: rows,
        row-gutter: row-gutter,
        align: default-align,
        fill: fill,
        ..body
    )),
    show-applicator,
)

#let scaled(value, n: 100%, pos: center + horizon, reflow: false) = grid.cell(
    align: pos,
    scale(x: n, y: n, value, reflow: reflow),
)

#let textbox(pos: horizon, text) = align(text, pos)
