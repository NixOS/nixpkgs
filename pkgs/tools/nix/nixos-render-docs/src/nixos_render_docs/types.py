from typing import Optional, Tuple, NamedTuple

OptionLoc = str | dict[str, str]
Option = dict[str, str | dict[str, str] | list[OptionLoc]]

RenderedOption = NamedTuple('RenderedOption', [('loc', list[str]),
                                               ('lines', list[str])])
