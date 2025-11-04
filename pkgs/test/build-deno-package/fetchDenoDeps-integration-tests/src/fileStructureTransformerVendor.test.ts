import {
  argsToCommand,
  assertEq,
  dec,
  globalPathPrefix,
  runTests,
  virtualFileToFs,
} from "./utils.ts";
import {
  Fixture,
  NestedVirtualFS,
  SetupFn,
  Test,
  Vars,
  VirtualFile,
  VirtualFS,
} from "./types.d.ts";

type FileStructureTransformerFixture = {
  inVendorJsonContent: string;
  inFetchedFilesFS: VirtualFS;
  outTransformedFilesFS: VirtualFS;
  outStdout?: string;
  outStderr?: string;
};

function checkFilesFs(f: FileStructureTransformerFixture) {
  function getOutPaths(jsonContent: string): Array<string> {
    return (JSON.parse(jsonContent) as Array<any>).map((e: any) =>
      e.outPath as string
    );
  }
  const inFilesExpected = [
    ...getOutPaths(f.inVendorJsonContent),
  ].sort();

  const inFilesActual = [
    ...Object.keys(f.inFetchedFilesFS),
  ].sort();

  assertEq(
    inFilesExpected,
    inFilesActual,
    "outPaths in npm.json don't match files in inFetchedFilesFS",
  );

  const inFilesExtractedActual = [
    ...Object.values(f.inFetchedFilesFS).map((v) => Object.keys(v)).flat(),
    "manifest.json",
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

function fixtureFrom(
  f: FileStructureTransformerFixture,
): Fixture {
  const bin = Deno.args[0];
  if (!bin) {
    throw new Error("test expects cli args[0]: binary to execute");
  }

  function pathToAbs(path: string) {
    return `${Deno.cwd()}/${globalPathPrefix}/${path}`;
  }

  const vars: Vars = {
    "url-file-map": pathToAbs("./vendor.json"),
    "cache-path": pathToAbs("./deno-cache"),
    "vendor-path": pathToAbs("./vendor"),
  };

  // checkFilesFs(f);

  return {
    inputs: {
      args: [
        bin,
        "--url-file-map",
        vars["url-file-map"],
        "--cache-path",
        vars["cache-path"],
        "--vendor-path",
        vars["vendor-path"],
      ],
      files: [
        {
          path: vars["url-file-map"],
          isReal: false,
          content: f.inVendorJsonContent,
        },
        ...Object.entries(f.inFetchedFilesFS).map(([path, content]) => ({
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
            path: `${vars["vendor-path"]}/${path}`,
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

const lockfileTransformerTests: Array<Test> = [
  {
    name: "jsr_2_files_1_package",
    fixture: fixtureFrom(
      {
        inVendorJsonContent: `[
  {
    "url": "https://jsr.io/@scope1/package1/version1/src/file1",
    "hash": "hash1",
    "hashAlgo": "sha256",
    "meta": {
      "registry": "jsr",
      "packageSpecifier": {
        "fullString": "@scope1/package1@version1",
        "registry": "jsr",
        "scope": "scope1",
        "name": "package1",
        "version": "version1",
        "suffix": null
      }
    },
    "outPath": "src/file1"
  },
  {
    "url": "https://jsr.io/@scope1/package1/version1/file2",
    "hash": "hash2",
    "hashAlgo": "sha256",
    "meta": {
      "registry": "jsr",
      "packageSpecifier": {
        "fullString": "@scope1/package1@version1",
        "registry": "jsr",
        "scope": "scope1",
        "name": "package1",
        "version": "version1",
        "suffix": null
      }
    },
    "outPath": "file2"
  }
]`,
        inFetchedFilesFS: {
          "src/file1": "file1_content",
          "file2": "file2_content",
        },
        outTransformedFilesFS: {
          "manifest.json": `{
  "modules": {
    "https://jsr.io/@scope1/package1/version1/file2": {},
    "https://jsr.io/@scope1/package1/version1/src/file1": {}
  }
}`,
          "jsr.io/@scope1/package1/version1/src/#file1_c147e.js":
            "file1_content",
          "jsr.io/@scope1/package1/version1/#file2_33778.js": "file2_content",
        },
      },
    ),
  },
  {
    name: "jsr_2_files_2_packages",
    fixture: fixtureFrom(
      {
        inVendorJsonContent: `[
  {
    "url": "https://jsr.io/@scope1/package1/version1/file1",
    "outPath": "file1"
  },
  {
    "url": "https://jsr.io/@scope2/package2/version1/file2",
    "outPath": "file2"
  }
]`,
        inFetchedFilesFS: {
          "file1": "file1_content",
          "file2": "file2_content",
        },
        outTransformedFilesFS: {
          "manifest.json": `{
  "modules": {
    "https://jsr.io/@scope1/package1/version1/file1": {},
    "https://jsr.io/@scope2/package2/version1/file2": {}
  }
}`,
          "jsr.io/@scope1/package1/version1/#file1_c147e.js": "file1_content",
          "jsr.io/@scope2/package2/version1/#file2_33778.js": "file2_content",
        },
      },
    ),
  },
  {
    name: "jsr_and_https",
    fixture: fixtureFrom(
      {
        inVendorJsonContent: `[
  {
    "url": "https://esm.sh/@scope1/package1/version1/file1",
    "outPath": "file1"
  },
  {
    "url": "https://jsr.io/@scope2/package2/version1/file2",
    "outPath": "file2"
  }
]`,
        inFetchedFilesFS: {
          "file1": "file1_content",
          "file2": "file2_content",
        },
        outTransformedFilesFS: {
          "manifest.json": `{
  "modules": {
    "https://esm.sh/@scope1/package1/version1/file1": {},
    "https://jsr.io/@scope2/package2/version1/file2": {}
  }
}`,
          "esm.sh/@scope1/package1/version1/#file1_c147e.js": "file1_content",
          "jsr.io/@scope2/package2/version1/#file2_33778.js": "file2_content",
        },
      },
    ),
  },
];

runTests(lockfileTransformerTests);
