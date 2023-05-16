from collections.abc import Sequence
<<<<<<< HEAD
from typing import Callable, Optional, NamedTuple
=======
from typing import Any, Callable, Optional, Tuple, NamedTuple
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

from markdown_it.token import Token

OptionLoc = str | dict[str, str]
Option = dict[str, str | dict[str, str] | list[OptionLoc]]

class RenderedOption(NamedTuple):
    loc: list[str]
    lines: list[str]
    links: Optional[list[str]] = None

RenderFn = Callable[[Token, Sequence[Token], int], str]
