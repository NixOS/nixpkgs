_md_escape_table = {
    ord('*'): '\\*',
    ord('<'): '\\<',
    ord('['): '\\[',
    ord('`'): '\\`',
    ord('.'): '\\.',
    ord('#'): '\\#',
    ord('&'): '\\&',
    ord('\\'): '\\\\',
}
def md_escape(s: str) -> str:
    return s.translate(_md_escape_table)
