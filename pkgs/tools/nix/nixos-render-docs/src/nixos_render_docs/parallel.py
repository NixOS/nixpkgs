# this module only has to exist because cpython has a global interpreter lock
# and markdown-it is pure python code. ideally we'd just use thread pools, but
# the GIL prohibits this.

import multiprocessing

from typing import Any, Callable, Iterable, Optional, TypeVar

R = TypeVar('R')
S = TypeVar('S')
T = TypeVar('T')
A = TypeVar('A')

pool_processes: Optional[int] = None

# this thing is impossible to type because there's so much global state involved.
# wrapping in a class to get access to Generic[] parameters is not sufficient
# because mypy is too weak, and unnecessarily obscures how much global state is
# needed in each worker to make this whole brouhaha work.
_map_worker_fn: Any = None
_map_worker_state_fn: Any = None
_map_worker_state_arg: Any = None

def _map_worker_init(*args: Any) -> None:
    global _map_worker_fn, _map_worker_state_fn, _map_worker_state_arg
    (_map_worker_fn, _map_worker_state_fn, _map_worker_state_arg) = args

# NOTE: the state argument is never passed by any caller, we only use it as a localized
# cache for the created state in lieu of another global. it is effectively a global though.
def _map_worker_step(arg: Any, state: Any = []) -> Any:
    global _map_worker_fn, _map_worker_state_fn, _map_worker_state_arg
    # if a Pool initializer throws it'll just be retried, leading to endless loops.
    # doing the proper initialization only on first use avoids this.
    if not state:
        state.append(_map_worker_state_fn(_map_worker_state_arg))
    return _map_worker_fn(state[0], arg)

def map(fn: Callable[[S, T], R], d: Iterable[T], chunk_size: int,
        state_fn: Callable[[A], S], state_arg: A) -> list[R]:
    """
    `[ fn(state, i) for i in d ]`  where `state = state_fn(state_arg)`, but using multiprocessing
    if `pool_processes` is not `None`. when using multiprocessing is used the state function will
    be run once in ever worker process and `multiprocessing.Pool.imap` will be used.

    **NOTE:** neither `state_fn` nor `fn` are allowed to mutate global state! doing so will cause
    discrepancies if `pool_processes` is not None, since each worker will have its own copy.

    **NOTE**: all data types that potentially cross a process boundary (so, all of them) must be
    pickle-able. this excludes lambdas, bound functions, local functions, and a number of other
    types depending on their exact internal structure. *theoretically* the pool constructor
    can transfer non-pickleable data to worker processes, but this only works when using the
    `fork` spawn method (and is thus not available on darwin or windows).
    """
    if pool_processes is None:
        state = state_fn(state_arg)
        return [ fn(state, i) for i in d ]
    with multiprocessing.Pool(pool_processes, _map_worker_init, (fn, state_fn, state_arg)) as p:
        return list(p.imap(_map_worker_step, d, chunk_size))
