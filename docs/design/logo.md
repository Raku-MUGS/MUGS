% Logo Ideas

*Reviewed 2021-03-06 by japhb*

**NOTE: The favorite small-size logo was chosen as interim project/org logo on
2021-03-06.**


# Concepts

The following are a few ideas for MUGS logos, in various sizes and contexts.
Each tries to represent some or all of the following:

* Play any genre of game
* Play with any user interface
* Friendly to assistive technologies
* Multi-user built in


# Tiny

The first example purely uses game-related icons, and is useful for example to
build a favicon or to display in a small squarish space in text mode.  It
focuses on representing genre variety, and can be "drawn" by just displaying
Unicode text in a 2 by 2 block.

```
♞🏹
⚄♠
```

The first row is `\c[BLACK CHESS KNIGHT, BOW AND ARROW]` and the second row is
`\c[DIE FACE-5, BLACK SPADE SUIT]`.  A very small variant simply swaps the two
rows as follows:

```
⚄♠
♞🏹
```

Depending on the font, this has slightly more balanced internal whitespace.


# Small

A slightly wider version would have MUGS on the top line, and the four symbols
from the square version above all in a row, like so:

```
MUGS
⚄♠♞🏹
```

Another direction is just to do the name MUGS, but spelled out in fullwidth
characters horizontally; this is twice as wide and half as tall:

```
Ｍ‭Ｕ‭Ｇ‭Ｓ‭
```

In fonts where all icons are wide, it may be necessary to combine these ideas
and put a fullwidth MUGS above the same set of four symbols:

```
Ｍ‭Ｕ‭Ｇ‭Ｓ‭
⚄♠♞🏹
```


# Medium

This variant still can be drawn textually, but is somewhat taller and much
wider and includes the MUGS name in fullwidth characters, surrounded with
various game-related Unicode:

```
 🖰‭ ‭🖮 ‭🎮‭🕹‭
‭🗨 Ｍ‭Ｕ‭Ｇ‭Ｓ‭🏆‭
‭  ♞ 🏹 ⚄ ♠
```

The center is MUGS spelled out in fullwidth characters.  Above it are the top
row icons, `\c[TWO BUTTON MOUSE, WIRED KEYBOARD, VIDEO GAME, JOYSTICK]`.
Below it the bottom row is `\c[BLACK CHESS KNIGHT, BOW AND ARROW, DIE FACE-5,
BLACK SPADE SUIT]`.  On the center row left is `\c[LEFT SPEECH BUBBLE]` and on
the center row right is `\c[TROPHY]`.

Unfortunately, this design falls prey to problems with different fonts and font
renderers deciding that several of these are nonsensically sized, which can
cause them to overlap or be unevenly spaced.

One possible solution to this problem is to have one line with just fullwidth
MUGS, and another with just icons -- starting with the ones that have
unambiguous widths:

```
Ｍ‭Ｕ‭Ｇ‭Ｓ
⚄♠♞🏹🏆🖰‭🎮
```

Thus the bottom row is now `\c[DIE FACE-5, BLACK SPADE SUIT, BLACK CHESS
KNIGHT, BOW AND ARROW, TROPHY, TWO BUTTON MOUSE, VIDEO GAME]`. One possible
extension to that is to widen the top row to make room for more icons below:

```
｛‭Ｍ‭Ｕ‭Ｇ‭Ｓ｝‭
⚄♠♞🏹🏆🖰‭🎮🗩‭
```

```
｟‭Ｍ‭Ｕ‭Ｇ‭Ｓ｠‭‭
⚄♠♞🏹🏆🖰‭🎮🗩‭
```

```
（‭Ｍ‭Ｕ‭Ｇ‭Ｓ‭）‭
⚄♠♞🏹🏆🖰‭🎮🗩‭
```

```
＜‭Ｍ‭Ｕ‭Ｇ‭Ｓ＞‭‭
⚄♠♞🏹🏆🖰‭🎮🗩‭
```

```
［‭Ｍ‭Ｕ‭Ｇ‭Ｓ］‭‭
⚄♠♞🏹🏆🖰‭🎮🗩‭
```

In each of the above variants, I've added one of the fullwidth bracketing pairs
around the top line, and used the extra width to add `\c[RIGHT SPEECH BUBBLE]`
to the end of the bottom row.  This ends up looking relatively balanced in both
Emacs GUI and gnome-terminal, especially the last variant (square brackets).


# Favorites

So far, the winning designs at each size are:

```
Tiny:
⚄♠
♞🏹

Small:
MUGS
⚄♠♞🏹

Medium:
［‭Ｍ‭Ｕ‭Ｇ‭Ｓ］‭‭
⚄♠♞🏹🏆🖰‭🎮🗩‭
```
