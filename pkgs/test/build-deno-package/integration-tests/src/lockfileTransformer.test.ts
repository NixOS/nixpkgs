import { runTests } from "./utils.ts";
import { Fixture, Test, Vars } from "./types.d.ts";

type LockfileTransformerFixture = {
  inLockJsonContent: string;
  outJsrJsonContent: string;
  outNpmJsonContent: string;
  outHttpsJsonContent: string;
  outStdout?: string;
  outStderr?: string;
};

function fixtureFrom(f: LockfileTransformerFixture): Fixture {
  const bin = Deno.args[0]
  if (!bin) {
    throw new Error("test expects cli args[0]: binary to execute")
  }

  const vars: Vars = {
    "in-path": "./first-deno.lock",
    "out-path-jsr": "./jsr.json",
    "out-path-npm": "./npm.json",
    "out-path-https": "./https.json",
  };

  return {
    inputs: {
      args: [
        bin,
        "--in-path",
        vars["in-path"],
        "--out-path-jsr",
        vars["out-path-jsr"],
        "--out-path-npm",
        vars["out-path-npm"],
        "--out-path-https",
        vars["out-path-https"],
      ],
      files: [{
        path: vars["in-path"],
        isReal: false,
        content: f.inLockJsonContent,
      }],
    },
    outputs: {
      files: {
        expected: [
          {
            path: vars["out-path-npm"],
            isReal: false,
            content: JSON.stringify(JSON.parse(f.outNpmJsonContent), null, 2),
          },
          {
            path: vars["out-path-https"],
            isReal: false,
            content: JSON.stringify(JSON.parse(f.outHttpsJsonContent), null, 2),
          },
          {
            path: vars["out-path-jsr"],
            isReal: false,
            content: JSON.stringify(JSON.parse(f.outJsrJsonContent), null, 2),
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
      inLockJsonContent: `
{
  "version": "5"
}`,
      outJsrJsonContent: `[]`,
      outNpmJsonContent: `[]`,
      outHttpsJsonContent: `[]`,
    }),
  },
  {
    name: "unused-keys",
    fixture: fixtureFrom({
      inLockJsonContent: `
{
  "version": "5",
  "other-keys-are-unused": "doesn't matter",
  "also-unused": "doesn't matter"
}`,
      outJsrJsonContent: `[]`,
      outNpmJsonContent: `[]`,
      outHttpsJsonContent: `[]`,
    }),
  },
  {
    name: "check-lock-version",
    fixture: fixtureFrom({
      inLockJsonContent: `
{
  "version": "unknown"
}`,
      outJsrJsonContent: `[]`,
      outNpmJsonContent: `[]`,
      outHttpsJsonContent: `[]`,
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
      inLockJsonContent: `
{
  "version": "5",
  "jsr": {
    "@scope/package@version1": {
      "integrity": "hash1"
    }
  }
}`,
      outJsrJsonContent: `
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
      outNpmJsonContent: `[]`,
      outHttpsJsonContent: `[]`,
    }),
  },

  {
    name: "just-https",
    fixture: fixtureFrom({
      inLockJsonContent: `
{
  "version": "5",
  "remote": {
    "https://url1.com/path": "hash1",
    "https://esm.sh/package@version?target=esnext": "hash2",
    "https://esm.sh/package@version": "hash3"
  }
}`,
      outJsrJsonContent: `[]`,
      outNpmJsonContent: `[]`,
      outHttpsJsonContent: `
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
      inLockJsonContent: `{
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
      outJsrJsonContent: `[]`,
      outNpmJsonContent: `
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
      outHttpsJsonContent: ` []`,
    }),
  },
  {
    name: "jsr+npm+https",
    fixture: fixtureFrom({
      inLockJsonContent: `{
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
      outJsrJsonContent: `[
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
      outNpmJsonContent: `[
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
      outHttpsJsonContent: `
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
