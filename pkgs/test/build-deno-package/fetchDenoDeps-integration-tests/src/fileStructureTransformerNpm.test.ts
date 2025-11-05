import {
  argsToCommand,
  assertEq,
  dec,
  runTests,
  virtualFileToFs,
} from "./utils.ts";
import type {
  Fixture,
  NestedVirtualFS,
  SetupFn,
  Test,
  Vars,
  VirtualFS,
} from "./types.d.ts";

type FileStructureTransformerFixture = {
  inNpmJsonContent: string;
  inFetchedFilesFS: NestedVirtualFS;
  inRegistryJsonFilesFS: VirtualFS;
  outTransformedFilesFS: VirtualFS;
  outStdout?: string;
  outStderr?: string;
};

async function toArchive(
  outPath: string,
  fs: VirtualFS,
) {
  const files = Object.entries(fs).map(([path, content]) => ({
    path: `./${path}`,
    isReal: false,
    content,
  }));
  await Promise.all(files.map(virtualFileToFs));

  // mimic how `npm pack` creates archives
  const command = argsToCommand([
    "tar",
    "-czf",
    outPath,
    "--transform",
    "s,^,package/,",
    ...files.map((v) => v.path),
  ]);
  const { code, stdout, stderr } = await command.output();
  if (code !== 0) {
    console.log(dec.decode(stdout));
    console.log(dec.decode(stderr));
  }
  assertEq(code, 0, "archiving failed");
}

function createArchives(f: FileStructureTransformerFixture): SetupFn {
  return async () => {
    await Promise.all(
      Object.entries(f.inFetchedFilesFS).map(([path, archiveFS]) =>
        toArchive(path, archiveFS)
      ),
    );
  };
}

function fixtureFrom(
  f: FileStructureTransformerFixture,
): Omit<Test, "name"> {
  return {
    fixture: _fixtureFrom(f),
    setupFn: createArchives(f),
  };
}

function checkFilesFs(f: FileStructureTransformerFixture) {
  function getOutPaths(jsonContent: string): Array<string> {
    return (JSON.parse(jsonContent) as Array<any>).map((e: any) =>
      e.outPath as string
    );
  }
  const inFilesExpected = [
    ...getOutPaths(f.inNpmJsonContent),
  ].sort();

  const inFilesActual =
    [
      ...Object.keys(f.inFetchedFilesFS),
      ...Object.keys(f.inRegistryJsonFilesFS),
    ].sort()

  assertEq(
    inFilesExpected,
    inFilesActual,
    "outPaths in npm.json don't match files in inFetchedFilesFS and inRegistryJsonFilesFS",
  );

  const inFilesExtractedActual = [
    ...Object.values(f.inFetchedFilesFS).map((v) => Object.keys(v)).flat(),
    ...Object.keys(f.inRegistryJsonFilesFS),
  ].sort();

  const transformedFilesFromFixture = Object.keys(f.outTransformedFilesFS)
    .sort();

  if (
    inFilesExtractedActual.length !==
      transformedFilesFromFixture.length
  ) {
    console.log("inFilesActual:", inFilesActual);
    console.log("transformedFiles:", transformedFilesFromFixture);
    console.log(
      "files in inFetchedFilesFS and inRegistryJsonFilesFS do not match outTransformedFilesFS",
    );
  }
}

function _fixtureFrom(
  f: FileStructureTransformerFixture,
): Fixture {
  const bin = Deno.args[0];
  if (!bin) {
    throw new Error("test expects cli args[0]: binary to execute");
  }

  const vars: Vars = {
    "common-lock-npm-path": "./npm.json",
    "deno-dir-path": "./deno-cache",
  };

  checkFilesFs(f);

  return {
    inputs: {
      args: [
        bin,
        "--common-lock-npm-path",
        vars["common-lock-npm-path"],
        "--deno-dir-path",
        vars["deno-dir-path"],
      ],
      files: [
        {
          path: vars["common-lock-npm-path"],
          isReal: false,
          content: f.inNpmJsonContent,
        },
        ...Object.entries(f.inRegistryJsonFilesFS).map(([path, content]) => ({
          path,
          isReal: false,
          content,
        })),
      ],
    },
    outputs: {
      files: {
        expected: [
          ...Object.entries(f.outTransformedFilesFS).map(([path, content]) => ({
            path: `${vars["deno-dir-path"]}/${path}`,
            isReal: false,
            content,
          })),
        ],
      },
      console: {
        expected: {
          stderr: f.outStderr || "",
          stdout: f.outStdout || "",
        },
      },
    },
  };
}

const fileStructureTransformerNpmTests: Array<Test> = [
  {
    name: "normal",
    ...fixtureFrom(
      {
        inNpmJsonContent: `[
  {
    "url": "url1",
    "hash": "hash1",
    "hashAlgo": "sha256",
    "meta": {
      "registry": "npm",
      "packageSpecifier": {
        "fullString": "@scope/package@version1",
        "registry": "npm",
        "scope": "scope",
        "name": "package",
        "version": "version1",
        "suffix": null
      }
    },
    "outPath": "archive1.tgz"
  }
]`,
        inFetchedFilesFS: {
          "archive1.tgz": {
            "src/file1": "file1_content",
            "file2": "file2_content",
          },
        },
        inRegistryJsonFilesFS: {},
        outTransformedFilesFS: {
          "npm/registry.npmjs.org/@scope/package/version1/src/file1":
            "file1_content",
          "npm/registry.npmjs.org/@scope/package/version1/file2":
            "file2_content",
        },
      },
    ),
  },
  {
    name: "registry.json",
    ...fixtureFrom(
      {
        inNpmJsonContent: `[
  {
    "url": "url1/archive1.tgz",
    "hash": "hash1",
    "hashAlgo": "sha256",
    "meta": {
      "registry": "npm",
      "packageSpecifier": {
        "fullString": "@scope/package@version1",
        "registry": "npm",
        "scope": "scope",
        "name": "package",
        "version": "version1",
        "suffix": null
      }
    },
    "outPath": "archive1.tgz"
  },
  {
    "url": "registry.json",
    "hash": "hash2",
    "hashAlgo": "sha256",
    "meta": {
      "registry": "npm",
      "packageSpecifier": {
        "fullString": "@scope/package@version1",
        "registry": "npm",
        "scope": "scope",
        "name": "package",
        "version": "version1",
        "suffix": null
      }
    },
    "outPath": "registry_json1"
  }
]`,
        inFetchedFilesFS: {
          "archive1.tgz": {
            "src/file1": "file1_content",
            "file2": "file2_content",
          },
        },
        inRegistryJsonFilesFS: {
          "registry_json1": "registry_json1_content",
        },
        outTransformedFilesFS: {
          "npm/registry.npmjs.org/@scope/package/version1/src/file1":
            "file1_content",
          "npm/registry.npmjs.org/@scope/package/version1/file2":
            "file2_content",
          "npm/registry.npmjs.org/@scope/package/registry.json":
            "registry_json1_content",
        },
      },
    ),
  },
];

runTests(fileStructureTransformerNpmTests);
