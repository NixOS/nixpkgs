{
  lib,
  stdenv,
  buildPythonPackage,
  cudaPackages,
  fetchurl,
  linkFarm,
  python,
  torch-tensorrt, # pkgs.torch-tensorrt, built with this package set

  # dependencies
  dllist,
  filelock,
  numpy,
  packaging,
  psutil,
  tensorrt,
  torch,
  typing-extensions,

  # tests
  cuda-core,
  expecttest,
  parameterized,
  pytestCheckHook,
  torchvision,
  transformers,
  writableTmpDirAsHomeHook,
}:
let
  # The pretrained torchvision models that the GPU checks load from torch.hub: ResNet-18 (tests/py/dynamo/runtime and
  # tests/py/ts/api) and MobileNetV2 (tests/py/ts/api).
  pretrainedWeights = [
    (fetchurl {
      url = "https://download.pytorch.org/models/resnet18-f37072fd.pth";
      hash = "sha256-83By/UfonF6CdiHFuv+nUAgZ94lrus7BYLGhbFYOB+w=";
    })
    (fetchurl {
      url = "https://download.pytorch.org/models/mobilenet_v2-b0353104.pth";
      hash = "sha256-sDUxBH/6zx4kiDGNzSq6ESbN4247/hqlywdwCu7umIk=";
    })
  ];
in
buildPythonPackage (finalAttrs: {
  inherit (torch-tensorrt)
    pname
    # The tests run from the source tree, patched as the libraries were.
    src
    patches
    version
    ;

  format = "wheel";
  __structuredAttrs = true;

  dontUseWheelUnpack = true;

  postUnpack = ''
    cp -rv "${torch-tensorrt.dist}" "$sourceRoot/dist"
    chmod +w "$sourceRoot/dist"
  '';

  # On x86_64-linux, setup.py requires TensorRT as the wheels for torch's CUDA major version: tensorrt-cu1x and its
  # -bindings and -libs. Nixpkgs' tensorrt provides them as one package.
  pythonRemoveDeps = [
    "tensorrt-cu12"
    "tensorrt-cu12-bindings"
    "tensorrt-cu12-libs"
    "tensorrt-cu13"
    "tensorrt-cu13-bindings"
    "tensorrt-cu13-libs"
  ];

  # On aarch64-linux, setup.py requires tensorrt at the minor version upstream builds with.
  pythonRelaxDeps = lib.optionals stdenv.hostPlatform.isAarch64 [ "tensorrt" ];

  dependencies = [
    dllist
    filelock
    numpy
    packaging
    psutil
    tensorrt
    torch
    typing-extensions
  ];

  # The wheel has copies of the libraries, torchtrtc and the headers, made before pkgs.torch-tensorrt's fixupPhase.
  # Use pkgs.torch-tensorrt's instead.
  postInstall = ''
    pushd "$out/${python.sitePackages}/torch_tensorrt" >/dev/null
    rm -r bin include lib
    ln -s ${torch-tensorrt}/bin bin
    ln -s ${torch-tensorrt}/include include
    ln -s ${torch-tensorrt}/lib lib
    popd >/dev/null
  '';

  # Upstream's extras (executorch, and all, which is the same) are left out: they require executorch>=1.4.1,<1.5, and
  # nixpkgs' is 1.5.0.
  # torch_tensorrt.kernels also needs cuda-core, which upstream lists in a dependency group rather than an extra.

  pythonImportsCheck = [ "torch_tensorrt" ];

  nativeCheckInputs = [
    expecttest
    parameterized
    pytestCheckHook
  ];

  pytestFlags = [
    # Drop upstream's `-n auto` (pytest-xdist), which runs a process per core on one GPU.
    "--override-ini=addopts="
  ];

  # Without a GPU, check only that libtorchtrt loads (with every symbol resolved) and that it doesn't link against
  # torch's transitive dependencies directly. passthru.gpuChecks run the tests that need a GPU.
  enabledTestPaths = [ "tests/py/core/test_libtorchtrt_linkage.py" ];

  passthru = {
    gpuChecks =
      # Upstream's test suites (tests/ci/suites.py) that run on one GPU without network access, split or merged so that
      # each derivation takes less than 10 minutes on an RTX 4090. Left out: the model, LLM and ts-models suites, which
      # download models; the distributed suite, which needs two GPUs; the ExecuTorch suite, which needs executorch 1.4
      # (see above); and the FlashInfer plugin test, which needs FlashInfer.
      lib.mapAttrs
        (
          suite:
          {
            enabledTestPaths,
            disabledTestPaths ? [ ],
            checkInputs ? [ ],
            preCheck ? "",
          }:
          finalAttrs.finalPackage.overrideAttrs (prevAttrs: {
            pname = "${prevAttrs.pname}-gpu-check-${suite}";

            requiredSystemFeatures = [ "cuda" ];

            # Report why each skipped test was skipped.
            pytestFlags = prevAttrs.pytestFlags ++ [ "-rs" ];

            nativeInstallCheckInputs =
              prevAttrs.nativeInstallCheckInputs
              ++ [
                # tests/py/dynamo/runtime/test_002_lazy_engine_init.py and test_mutable_torchtrt_module.py compile
                # ResNet-18.
                torchvision
                # tests/py/dynamo/runtime/test_hf_static_cache_xfail.py compiles GPT-2.
                transformers
                # Triton, which the plugin tests use, caches kernels in $HOME.
                writableTmpDirAsHomeHook
              ]
              ++ checkInputs;

            preCheck =
              (prevAttrs.preCheck or "")
              + ''
                export TORCH_HOME="$(mktemp -d)"
                mkdir -p "$TORCH_HOME/hub/checkpoints"
              ''
              + lib.concatMapStrings (weights: ''
                ln -s ${weights} "$TORCH_HOME/hub/checkpoints/${weights.name}"
              '') pretrainedWeights
              + preCheck;

            inherit enabledTestPaths disabledTestPaths;

            doInstallCheck = true;
          })
        )
        (
          {
            dynamo-hlo = {
              enabledTestPaths = [ "tests/py/dynamo/hlo" ];
              disabledTestPaths = [ "tests/py/dynamo/hlo/test_attention.py" ];
            };
            dynamo-hlo-attention.enabledTestPaths = [ "tests/py/dynamo/hlo/test_attention.py" ];
            dynamo-lowering.enabledTestPaths = [ "tests/py/dynamo/lowering" ];
            dynamo-partitioning.enabledTestPaths = [ "tests/py/dynamo/partitioning" ];
            dynamo-runtime.enabledTestPaths = [ "tests/py/dynamo/runtime" ];
            kernels = {
              enabledTestPaths = [ "tests/py/kernels" ];
              # torch_tensorrt.kernels needs cuda-core.
              checkInputs = [ cuda-core ];
            };
            plugins-automatic = {
              enabledTestPaths = [ "tests/py/dynamo/automatic_plugin" ];
              # Needs FlashInfer; upstream runs it as its own suite.
              disabledTestPaths = [ "tests/py/dynamo/automatic_plugin/test_flashinfer_rmsnorm.py" ];
            };
            py-core.enabledTestPaths = [ "tests/py/core" ];
            torch-compile-backend.enabledTestPaths = [ "tests/py/dynamo/backend" ];
            ts-api = {
              enabledTestPaths = [ "tests/py/ts/api" ];
              disabledTestPaths = [
                # Load pretrained VGG-16 and AlexNet (760 MB of weights).
                "tests/py/ts/api/test_ts_backend.py"
                # Loads pretrained ResNet-50, and EfficientNet-B0 from timm.
                "tests/py/ts/api/test_embed_engines.py"
              ];
              # Write the TorchScript modules that test_collections.py loads, as upstream's runner does first.
              preCheck = ''
                pushd tests/modules
                ${python.interpreter} hub.py
                popd
              '';
            };
            ts-integrations.enabledTestPaths = [ "tests/py/ts/integrations" ];
          }
          # The converter tests (about 2100), by the first letter of their file names.
          // lib.genAttrs' [ "a-b" "c-f" "g-m" "n-r" "s-z" ] (
            letters:
            lib.nameValuePair "dynamo-converters-${letters}" {
              enabledTestPaths = [ "tests/py/dynamo/conversion/test_[${letters}]*.py" ];
            }
          )
        )
      // {
        # Compiles a randomly initialized torchvision ResNet-18 with the dynamo frontend, the TorchScript frontend (from
        # Python and with torchtrtc) and the TorchScript backend API, saves and loads it as an ExportedProgram and as
        # TorchScript, compiles einsum and bitwise_not with the TorchScript frontend alone, compiles a randomly
        # initialized transformers GPT-2 with torch.compile, and runs a worker with torchtrtrun. Each check requires
        # TensorRT engines that the C++ runtime runs (as the profiler records), and outputs that match PyTorch's; two
        # controls without engines must fail the check.
        models =
          ((cudaPackages.writeGpuTestPython.override { python3Packages = python.pkgs; })
            {
              name = "torch-tensorrt-models";
              libraries = ps: [
                finalAttrs.finalPackage
                ps.torchvision
                ps.transformers
              ];
            }
            ''
              import os
              import subprocess
              import sys
              import tempfile

              import torch
              import torch_tensorrt
              import torchvision
              import transformers
              from torch_tensorrt.dynamo.runtime import TorchTensorRTModule

              package = os.path.dirname(os.path.realpath(torch_tensorrt.__file__))
              assert package.startswith("${finalAttrs.finalPackage}/"), package
              features = torch_tensorrt.ENABLED_FEATURES
              assert features.torch_tensorrt_runtime and features.torchscript_frontend, features


              def engines(module):
                  """Count the TensorRT engines in a compiled module."""
                  if isinstance(module, torch.jit.ScriptModule):
                      return str(module.inlined_graph).count("tensorrt::execute_engine")
                  return sum(isinstance(m, TorchTensorRTModule) for m in module.modules()) + sum(
                      node.target is torch.ops.tensorrt.execute_engine.default
                      for m in module.modules()
                      if isinstance(m, torch.fx.GraphModule)
                      for node in m.graph.nodes
                  )


              def check(name, expected, run, engines=None):
                  """Check that run() runs TensorRT engines (each once, if their number is given) with the C++ runtime's
                  tensorrt::execute_engine op, and that its output matches expected."""
                  with torch.profiler.profile(activities=[torch.profiler.ProfilerActivity.CPU]) as profile:
                      actual = run()
                  executed = sum(event.name == "tensorrt::execute_engine" for event in profile.events())
                  expected, actual = expected.flatten().float(), actual.flatten().float()
                  similarity = torch.nn.functional.cosine_similarity(expected, actual, dim=0).item()
                  print(f"{name}: {engines} engines, {executed} executed, cosine similarity {similarity:.6f}")
                  assert executed >= 1 and engines in (None, executed), f"{name}: {engines} engines, {executed} executed"
                  assert similarity > 0.99, f"{name}: cosine similarity {similarity}"


              def control(name, expected, run, engines=None):
                  """Check that check() fails for run(), which has no TensorRT engines."""
                  try:
                      check(name, expected, run, engines)
                  except AssertionError as error:
                      print(f"{name}: failed the check, as it should: {error}")
                  else:
                      raise AssertionError(f"{name}: passed the check without TensorRT engines")


              torch.manual_seed(0)
              with torch.no_grad(), tempfile.TemporaryDirectory() as tmp:
                  resnet = torchvision.models.resnet18().eval().cuda()
                  x = torch.randn(2, 3, 224, 224, device="cuda")
                  expected = resnet(x)

                  trt = torch_tensorrt.compile(
                      resnet, ir="dynamo", inputs=[x], min_block_size=1, use_python_runtime=False
                  )
                  check("ResNet-18, dynamo", expected, lambda: trt(x), engines(trt))
                  unconverted = torch_tensorrt.compile(
                      resnet, ir="dynamo", inputs=[x], min_block_size=10**6, use_python_runtime=False
                  )
                  control("ResNet-18, dynamo, nothing converted", expected, lambda: unconverted(x), engines(unconverted))

                  torch_tensorrt.save(trt, f"{tmp}/resnet18.ep", inputs=[x])
                  ep = torch_tensorrt.load(f"{tmp}/resnet18.ep").module()
                  check("ResNet-18, ExportedProgram", expected, lambda: ep(x), engines(ep))
                  torch_tensorrt.save(trt, f"{tmp}/resnet18.ts", output_format="torchscript", inputs=[x])
                  ts = torch.jit.load(f"{tmp}/resnet18.ts")
                  check("ResNet-18, TorchScript", expected, lambda: ts(x), engines(ts))

                  traced = torch.jit.trace(resnet, x)
                  control("ResNet-18, traced, not compiled", expected, lambda: traced(x), engines(traced))
                  trt_ts = torch_tensorrt.compile(traced, ir="ts", inputs=[torch_tensorrt.Input(x.shape)])
                  check("ResNet-18, TorchScript frontend", expected, lambda: trt_ts(x), engines(trt_ts))
                  traced.save(f"{tmp}/resnet18-traced.ts")
                  torchtrtc = os.path.join(package, "bin", "torchtrtc")
                  subprocess.run(
                      [torchtrtc, f"{tmp}/resnet18-traced.ts", f"{tmp}/resnet18-torchtrtc.ts", "(2,3,224,224)"],
                      check=True,
                  )
                  trtc = torch.jit.load(f"{tmp}/resnet18-torchtrtc.ts")
                  check("ResNet-18, torchtrtc", expected, lambda: trtc(x), engines(trtc))

                  # The TorchScript frontend's einsum and bitwise_not converters, without falling back to PyTorch.
                  class Einsum(torch.nn.Module):
                      def forward(self, a, b):
                          return torch.einsum("ij,jk->ik", a, b)

                  class BitwiseNot(torch.nn.Module):
                      def forward(self, a):
                          return torch.bitwise_not(a)

                  for module, inputs in [
                      (Einsum(), [torch.randn(4, 8, device="cuda"), torch.randn(8, 3, device="cuda")]),
                      (BitwiseNot(), [torch.randint(-128, 128, (4, 8), dtype=torch.int32, device="cuda")]),
                  ]:
                      compiled = torch_tensorrt.compile(
                          torch.jit.script(module),
                          ir="ts",
                          inputs=[torch_tensorrt.Input(i.shape, dtype=i.dtype) for i in inputs],
                          min_block_size=1,
                          require_full_compilation=True,
                      )
                      name = f"{type(module).__name__}, TorchScript frontend"
                      check(name, module(*inputs), lambda: compiled(*inputs), engines(compiled))

                  # torch_tensorrt._C creates the engines of the TorchScript backend API, and the lowered module runs
                  # them with libtorchtrt's execute_engine function rather than the op, so only the outputs are checked.
                  spec = {"forward": torch_tensorrt.ts.TensorRTCompileSpec(inputs=[torch_tensorrt.Input(x.shape)])}
                  lowered = torch._C._jit_to_backend("tensorrt", torch.jit.script(resnet), spec)
                  similarity = torch.nn.functional.cosine_similarity(
                      expected.flatten(), lowered(x).flatten(), dim=0
                  ).item()
                  print(f"ResNet-18, TorchScript backend API: cosine similarity {similarity:.6f}")
                  assert similarity > 0.99, similarity

                  # Exporting GPT-2 (ir="dynamo") fails: TensorRT's builder reports a Myelin internal error for a
                  # constant (logical memory size 768, payload size 12288).
                  config = transformers.GPT2Config(vocab_size=128, n_positions=64, n_embd=64, n_layer=2, n_head=4)
                  gpt2 = transformers.GPT2LMHeadModel(config).eval().cuda()
                  ids = torch.randint(0, 128, (1, 16), device="cuda")
                  expected = gpt2(ids, use_cache=False).logits
                  compiled = torch.compile(
                      gpt2, backend="tensorrt", options={"min_block_size": 1, "use_python_runtime": False}
                  )
                  compiled(ids, use_cache=False)  # compile before profiling
                  check("GPT-2, torch.compile", expected, lambda: compiled(ids, use_cache=False).logits)

                  # torchtrtrun, upstream's launcher for distributed inference, runs one worker.
                  with open(f"{tmp}/worker.py", "w") as worker:
                      worker.write(
                          "import os, torch, torch_tensorrt\n"
                          "assert (os.environ['RANK'], os.environ['WORLD_SIZE']) == ('0', '1'), os.environ\n"
                          "torch.set_grad_enabled(False)\n"
                          "linear = torch.nn.Linear(8, 8).eval().cuda()\n"
                          "x = torch.randn(2, 8, device='cuda')\n"
                          "trt = torch_tensorrt.compile(linear, ir='dynamo', inputs=[x], min_block_size=1)\n"
                          "torch.testing.assert_close(trt(x), linear(x), rtol=1e-2, atol=1e-2)\n"
                          "print('worker', os.environ['RANK'], 'ran TensorRT')\n"
                      )
                  torchtrtrun = os.path.join(os.path.dirname(sys.executable), "torchtrtrun")
                  run = subprocess.run([torchtrtrun, f"{tmp}/worker.py"], check=True, capture_output=True, text=True)
                  print(run.stderr + run.stdout)
                  assert "worker 0 ran TensorRT" in run.stdout, run.stdout
            ''
          ).gpuCheck;
      };

    gpuCheck = linkFarm "${finalAttrs.finalPackage.name}-gpu-checks" finalAttrs.passthru.gpuChecks;

    # The version and source are pkgs.torch-tensorrt's, so updating it updates this package too.
    updateScript = {
      command = torch-tensorrt.updateScript;
      attrPath = "torch-tensorrt";
    };
  };

  meta = {
    # Explicitly inherit from pkgs.torch-tensorrt's meta to avoid pulling in attributes added by stdenv.mkDerivation.
    inherit (torch-tensorrt.meta)
      changelog
      description
      downloadPage
      homepage
      license
      maintainers
      platforms
      problems
      teams
      ;
  };
})
