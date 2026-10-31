# Binary patches for SP Flash Tool 6, applied by r2patch.py.
# Offsets are file offsets into SPFlashToolV6 of SP_Flash_Tool_v6.2228_Linux.
#
# The UI hardcodes light backgrounds via stylesheets while taking text
# colors from the palette, making it unreadable under dark themes. NUL the
# first byte of each selector/property string (they sit in NUL-padded
# .rodata), so Qt sees an empty string and ignores the rule, making widgets
# follow the system theme in both light and dark palettes.

HUNKS = {
    "spflashtool6": [
        (0x1181F0, b"QMenu {", b"\x00Menu {"),
        (0x119480, b"background-color:", b"\x00ackground-color:"),
        (0x11A0D0, b"QHeaderView::section", b"\x00HeaderView::section"),
        (0x11ADF0, b"border: 1px solid", b"\x00order: 1px solid"),
        (0x11E030, b"alternate-background-color", b"\x00lternate-background-color"),
        (0x11E0C8, b"QTabBar::tab:selected", b"\x00TabBar::tab:selected"),
        # Help/status HTML uses hardcoded black text, unreadable on dark
        # palettes: `span style=" color:#000000;"` (three occurrences)
        (0x11C51B, b"000000", b"808080"),
        (0x2E769B, b"000000", b"808080"),
        (0x2EA4A4, b"000000", b"808080"),
    ],
}
