import os
import time
from typing import Any, Callable
import multiprocessing
from functools import partial

load_average_supported = hasattr(os, 'getloadavg')
delays = 0
nix_build_cores = int(os.environ.get('NIX_LOAD_LIMIT', os.environ.get('NIX_BUILD_CORES', "-1")))

def CPUThreadCount(enable=True):
    if not enable:
        return 1
    else:
        from .Common import globalParameters
        cpuThreads = nix_build_cores if nix_build_cores else globalParameters["CpuThreads"]
        if cpuThreads < 1:
            if os.name == "nt":
                cpuThreads = os.cpu_count()
            else:
                cpuThreads = len(os.sched_getaffinity(0))
        return max(1, min(cpuThreads, 32))


def OverwriteGlobalParameters(newGlobalParameters):
    from . import Common

    Common.globalParameters.clear()
    Common.globalParameters.update(newGlobalParameters)


def pcallWithGlobalParamsMultiArg(f, args, newGlobalParameters):
    OverwriteGlobalParameters(newGlobalParameters)
    return f(*args)


def pcallWithGlobalParamsSingleArg(f, arg, newGlobalParameters):
    OverwriteGlobalParameters(newGlobalParameters)
    return f(arg)

def worker_function(args, function, multiArg, shared_dict):
    if load_average_supported:
        global delays
        lim = CPUThreadCount()
        while (os.getloadavg()[0] - delays) > lim:
            time.sleep(1)
            delays += 1
    OverwriteGlobalParameters(shared_dict)
    if multiArg:
        return function(*args)
    else:
        return function(args)

def imap_with_progress(pool, func, iterable, total, message):
    results = []
    idx = 0
    for result in pool.imap(func, iterable, chunksize=max(1, total // 2000)):
        results.append(result)
        idx += 1
        if idx % (1 + (total // 100)) == 0:
            print(f"{message}\t{idx: 5d}/{total: 5d}")
    print(f"\n{message} done!\t{idx: 5d}/{total: 5d}")
    return results

def _with_idx(func, parts):
    idx, obj = parts
    return idx, func(obj)

def imap_with_progress2(pool, func, iterable, total, message):
    results = [None] * total

    fn = partial(_with_idx, func)
    for idx, result in enumerate(pool.imap_unordered(fn, enumerate(iterable), chunksize=max(1, total // 2500))):
        orig_idx, item_result = result
        results[orig_idx] = item_result
        if idx % (1 + (total // 100)) == 0:
            print(f"{message}\t{idx+1: 5d}/{total: 5d}")
    print(f"\n{message} done!\t{idx+1: 5d}/{total: 5d}")
    return results

def ParallelMap(
    function: Callable,
    objects: Any,
    message: str = "",
    enable: bool = True,
    multiArg: bool = True,
    return_as: str = "list"
) -> list:
    """Executes a function over a list of objects in parallel or sequentially.

    This function is generally equivalent to ``list(map(function, objects))``. However, it provides
    additional functionality to run in parallel, depending on the 'enable' flag and available CPU
    threads.

    Args:
        function: The function to apply to each item in 'objects'. If 'multiArg' is True, 'function'
                  should accept multiple arguments.
        objects: An iterable of objects to be processed by 'function'. If 'multiArg' is True, each
                 item in 'objects' should be an iterable of arguments for 'function'.
        message: Optional; a message describing the operation. Default is an empty string.
        enable: Optional; if False, disables parallel execution and runs sequentially. Default is True.
        multiArg: Optional; if True, treats each item in 'objects' as multiple arguments for
                  'function'. Default is True.

    Returns:
        A list containing the results of applying **function** to each item in **objects**.
    """
    if return_as != "list":
        print(f"Ignoring unknown return_as {return_as} for {message}\n")
    from .Common import globalParameters

    threadCount = CPUThreadCount(enable)

    if not hasattr(objects, "__len__"):
        objects = list(objects)

    objLen = len(objects)
    if objLen == 0:
        return []

    f = (lambda x: function(*x)) if multiArg else function
    if objLen == 1:
        print(f"{message}: (1 task)")
        return [f(x) for x in objects]

    extra_message = (
        f": {threadCount} thread(s)" + f", {objLen} tasks"
        if objLen
        else ""
    )

    print(f"\nParallelMap {message}{extra_message}\n")

    if threadCount <= 1:
        return [f(x) for x in objects]

    ctx = multiprocessing.get_context('forkserver')
    multiprocessing.set_forkserver_preload(["tensile.Common", "tensile.Parallel", "tensile.TensileCreateLibrary"])
    with ctx.Pool(processes=threadCount, maxtasksperchild=1024) as pool:
            worker = partial(worker_function, function=function, multiArg=multiArg, shared_dict=globalParameters)
            return list(imap_with_progress(pool, worker, objects, objLen, message))

# Compat with tensilelite folder version of tensile that's
# in-tree with hipblaslt, not needed for tensile for rocm-6.2
ParallelMap2 = ParallelMap
ParallelMapReturnAsGenerator = ParallelMap
