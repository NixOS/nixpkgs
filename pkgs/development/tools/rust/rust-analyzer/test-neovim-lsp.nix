{ runCommand, cargo, neovim, rust-analyzer, rustc }:
runCommand "test-neovim-rust-analyzer" {
  nativeBuildInputs = [ cargo neovim rust-analyzer rustc ];

  testRustSrc = /* rust */ ''
    fn main() {
      let mut var = vec![None];
      var.push(Some("hello".to_owned()));
    }
  '';

  nvimConfig = /* lua */ ''
    vim.lsp.buf_attach_client(vim.api.nvim_get_current_buf(), vim.lsp.start_client({
      cmd = { "rust-analyzer" },
      handlers = {
        ["$/progress"] = function(_, msg, ctx)
          if msg.token == "rustAnalyzer/Indexing" and msg.value.kind == "end" then
            vim.cmd("goto 23") -- let mut |var =...
            vim.lsp.buf.hover()
          end
        end,
        ["textDocument/hover"] = function(_, msg, ctx)
          -- Keep newlines.
          io.write(msg.contents.value)
          vim.cmd("q")
        end,
      },
      on_error = function(code)
        print("error: " .. code)
        vim.cmd("q")
      end
    }))
  '';

} ''
  # neovim requires a writable HOME.
  export HOME="$(pwd)"

  cargo new --bin test-rust-analyzer
  cd test-rust-analyzer
  cat <<<"$testRustSrc" >src/main.rs
  cat <<<"$nvimConfig" >script.lua

  # `-u` doesn't work
  result="$(nvim --headless +'lua dofile("script.lua")' src/main.rs)"
  echo "$result"
  [[ "$result" == *"var: Vec<Option<String>>"* ]]
  touch $out
''
