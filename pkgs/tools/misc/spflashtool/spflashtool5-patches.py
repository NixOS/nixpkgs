# Binary patches for SP Flash Tool 5, applied by r2patch.py.
# Offsets are file offsets into the binaries of SP_Flash_Tool_v5.2228_Linux.

HUNKS = {
    # The UI hardcodes a light table-header tint, greenish alternating rows
    # and a black-text frame via stylesheets while taking the rest from the
    # palette. NUL the first byte of each selector string (they sit in
    # NUL-padded .rodata), so Qt sees an empty string and ignores the rule,
    # making the widgets follow the palette cleanly.
    "flash_tool": [
        (0x15DCB8, b"alternate-background-color", b"\x00lternate-background-color"),
        (0x15EB78, b"border: 1px solid", b"\x00order: 1px solid"),
        (0x15FE38, b"QHeaderView::section", b"\x00HeaderView::section"),
    ],
    # Kernel >= 6.1 (commit 66aad7d8d3ec) returns EOPNOTSUPP for
    # TIOCSBRK/TIOCCBRK on cdc_acm devices without USB_CDC_CAP_BRK, and
    # SP Flash Tool treats that ioctl failure as fatal. NOP out the error
    # branch taken when the ioctl result is nonzero:
    #
    #   0x95c6d:  85 c0     test eax, eax
    #   0x95c6f:  75 40     jne 0x95cb1      <- jumps to the fatal-error path
    "libflashtoolEx.so": [
        (0x95C6F, asm("jne 0x95cb1"), asm("nop", "nop")),
    ],
    # Same check in the other copy of the library, this time via a flag set
    # with setne; force it to "success" instead:
    #
    #   0x3b751c:  83 7d b8 00         cmp dword [rbp - 0x48], 0
    #   0x3b7520:  0f 95 c0            setne al    <- nonzero ioctl result flag
    #   0x3b7523:  84 c0               test al, al
    #   0x3b7525:  0f 84 99 00 00 00   je 0x3b75c4
    "libflashtool.v1.so": [
        (0x3B7520, asm("setne al"), asm("xor al, al", "nop")),
    ],
}
