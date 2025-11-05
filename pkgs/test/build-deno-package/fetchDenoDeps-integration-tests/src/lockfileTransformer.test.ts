import { runTests } from "./utils.ts";
import type { Fixture, Test, Vars } from "./types.d.ts";

type LockfileTransformerFixture = {
  denoLockContent: string;
  commonLockJsrContent: string;
  commonLockNpmContent: string;
  commonLockHttpsContent: string;
  outStdout?: string;
  outStderr?: string;
};

function fixtureFrom(f: LockfileTransformerFixture): Fixture {
  const bin = Deno.args[0];
  if (!bin) {
    throw new Error("test expects cli args[0]: binary to execute");
  }

  type VarNames = {
    commonLockJsrPath: null;
    commonLockHttpsPath: null;
    commonLockNpmPath: null;
    denoLockPath: null;
  }
  const vars: Vars<VarNames> = {
    commonLockJsrPath: {value:"./jsr.json",flag:"--common-lock-jsr-path"},
    commonLockHttpsPath: {value:"./https.json",flag:"--common-lock-https-path"},
    commonLockNpmPath: {value:"./npm.json",flag:"--common-lock-npm-path"},
    denoLockPath: {value:"./first-deno.lock",flag:"--deno-lock-path"},
  };

  return {
    inputs: {
      args: [
        bin,
        vars.commonLockJsrPath.flag,
        vars.commonLockJsrPath.value,
        vars.commonLockHttpsPath.flag,
        vars.commonLockHttpsPath.value,
        vars.commonLockNpmPath.flag,
        vars.commonLockNpmPath.value,
        vars.denoLockPath.flag,
        vars.denoLockPath.value,
      ],
      files: [{
        path: vars.denoLockPath.value,
        isReal: false,
        content: f.denoLockContent,
      }],
    },
    outputs: {
      files: {
        expected: [
          {
            path: vars.commonLockJsrPath.value,
            isReal: false,
            content: JSON.stringify(JSON.parse(f.commonLockJsrContent), null, 2),
          },
          {
            path: vars.commonLockNpmPath.value,
            isReal: false,
            content: JSON.stringify(JSON.parse(f.commonLockNpmContent), null, 2),
          },
          {
            path: vars.commonLockHttpsPath.value,
            isReal: false,
            content: JSON.stringify(JSON.parse(f.commonLockHttpsContent), null, 2),
          },
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
    name: "empty-lock",
    fixture: fixtureFrom({
      denoLockContent: `
{
  "version": "5"
}`,
      commonLockJsrContent: `[]`,
      commonLockNpmContent: `[]`,
      commonLockHttpsContent: `[]`,
    }),
  },
  {
    name: "unused-keys",
    fixture: fixtureFrom({
      denoLockContent: `
{
  "version": "5",
  "other-keys-are-unused": "doesn't matter",
  "also-unused": "doesn't matter"
}`,
      commonLockJsrContent: `[]`,
      commonLockNpmContent: `[]`,
      commonLockHttpsContent: `[]`,
    }),
  },
  {
    name: "check-lock-version",
    fixture: fixtureFrom({
      denoLockContent: `
{
  "version": "unknown"
}`,
      commonLockJsrContent: `[]`,
      commonLockNpmContent: `[]`,
      commonLockHttpsContent: `[]`,
      outStderr: `
      WARNING: using deno.lock with a version unknown by nixpkgs buildDenoPackage: "unknown"

      The build might fail because of this.

      Consider creating an issue in nixpkgs, if it there is not already one for that version.

`,
    }),
  },
  {
    name: "just-jsr",
    fixture: fixtureFrom({
      denoLockContent: `
{
  "version": "5",
  "jsr": {
    "@scope/package@version1": {
      "integrity": "hash1"
    }
  }
}`,
      commonLockJsrContent: `
[
  {
    "url": "https://jsr.io/@scope/package/version1_meta.json",
    "hash": "hash1",
    "hashAlgo": "sha256",
    "meta": {
      "registry": "jsr",
      "packageSpecifier": {
        "fullString": "@scope/package@version1",
        "registry": "jsr",
        "scope": "scope",
        "name": "package",
        "version": "version1",
        "suffix": null
      }
    }
  }
]`,
      commonLockNpmContent: `[]`,
      commonLockHttpsContent: `[]`,
    }),
  },

  {
    name: "just-https",
    fixture: fixtureFrom({
      denoLockContent: `
{
  "version": "5",
  "remote": {
    "https://url1.com/path": "hash1",
    "https://esm.sh/package@version?target=esnext": "hash2",
    "https://esm.sh/package@version": "hash3"
  }
}`,
      commonLockJsrContent: `[]`,
      commonLockNpmContent: `[]`,
      commonLockHttpsContent: `
[
  {
    "url": "https://url1.com/path",
    "hash": "hash1",
    "hashAlgo": "sha256",
    "meta": {
      "registry": "url1.com"
    }
  },
  {
    "url": "https://esm.sh/package@version?target=esnext",
    "hash": "hash2",
    "hashAlgo": "sha256",
    "meta": {
      "registry": "esm.sh",
      "original_url": "https://esm.sh/package@version?target=esnext"
    }
  },
  {
    "url": "https://esm.sh/package@version?target=denonext",
    "hash": "hash3",
    "hashAlgo": "sha256",
    "meta": {
      "registry": "esm.sh",
      "original_url": "https://esm.sh/package@version"
    }
  }
]`,
    }),
  },
  {
    name: "just-npm",
    fixture: fixtureFrom({
      denoLockContent: `{
  "version": "5",
  "npm": {
    "@scope/package@version1": {
      "integrity": "hash1"
    },
    "package@version2": {
      "integrity": "hash2"
    }
  }
}`,
      commonLockJsrContent: `[]`,
      commonLockNpmContent: `
[
  {
    "url": "https://registry.npmjs.org/@scope/package/-/package-version1.tgz",
    "hash": "hash1",
    "hashAlgo": "sha512",
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
    }
  },
  {
    "url": "https://registry.npmjs.org/package/-/package-version2.tgz",
    "hash": "hash2",
    "hashAlgo": "sha512",
    "meta": {
      "registry": "npm",
      "packageSpecifier": {
        "fullString": "package@version2",
        "registry": "npm",
        "scope": null,
        "name": "package",
        "version": "version2",
        "suffix": null
      }
    }
  }
]`,
      commonLockHttpsContent: ` []`,
    }),
  },
  {
    name: "jsr+npm+https",
    fixture: fixtureFrom({
      denoLockContent: `{
  "version": "5",
  "jsr": {
    "@scope/package@version1": {
      "integrity": "hash1"
    }
  },
  "npm": {
    "@scope/package@version1": {
      "integrity": "hash1"
    },
    "package@version2": {
      "integrity": "hash2"
    }
  },
  "remote": {
    "https://url1.com/path": "hash1",
    "https://esm.sh/package@version?target=esnext": "hash2",
    "https://esm.sh/package@version": "hash3"
  }
}`,
      commonLockJsrContent: `[
  {
    "url": "https://jsr.io/@scope/package/version1_meta.json",
    "hash": "hash1",
    "hashAlgo": "sha256",
    "meta": {
      "registry": "jsr",
      "packageSpecifier": {
        "fullString": "@scope/package@version1",
        "registry": "jsr",
        "scope": "scope",
        "name": "package",
        "version": "version1",
        "suffix": null
      }
    }
  }
]`,
      commonLockNpmContent: `[
  {
    "url": "https://registry.npmjs.org/@scope/package/-/package-version1.tgz",
    "hash": "hash1",
    "hashAlgo": "sha512",
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
    }
  },
  {
    "url": "https://registry.npmjs.org/package/-/package-version2.tgz",
    "hash": "hash2",
    "hashAlgo": "sha512",
    "meta": {
      "registry": "npm",
      "packageSpecifier": {
        "fullString": "package@version2",
        "registry": "npm",
        "scope": null,
        "name": "package",
        "version": "version2",
        "suffix": null
      }
    }
  }
]`,
      commonLockHttpsContent: `
[
  {
    "url": "https://url1.com/path",
    "hash": "hash1",
    "hashAlgo": "sha256",
    "meta": {
      "registry": "url1.com"
    }
  },
  {
    "url": "https://esm.sh/package@version?target=esnext",
    "hash": "hash2",
    "hashAlgo": "sha256",
    "meta": {
      "registry": "esm.sh",
      "original_url": "https://esm.sh/package@version?target=esnext"
    }
  },
  {
    "url": "https://esm.sh/package@version?target=denonext",
    "hash": "hash3",
    "hashAlgo": "sha256",
    "meta": {
      "registry": "esm.sh",
      "original_url": "https://esm.sh/package@version"
    }
  }
]
`,
    }),
  },
];

runTests(lockfileTransformerTests);
