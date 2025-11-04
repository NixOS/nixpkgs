export type Args = Array<string>;
export type Vars = Record<string, string>;
export type VirtualFile = {
  path: string;
  content: string;
  isReal: boolean;
};
export type Console = {
  stderr?: string;
  stdout?: string;
  code?: number;
};
export type Fixture = {
  inputs: {
    args: Args;
    files: Array<VirtualFile>;
  };
  outputs: {
    files: {
      actual?: Array<VirtualFile>;
      expected: Array<VirtualFile>;
    };
    console: {
      actual?: Console;
      expected: Console;
    };
  };
};
export type TeardownFn = () => Promise<void>;
export type SetupFn = () => Promise<TeardownFn | void>;
export type Test = {
  name: string;
  fixture: Fixture;
  setupFn?: SetupFn;
};
export type VirtualFS = Record<string, string>;
export type NestedVirtualFS = Record<string, VirtualFS>;
