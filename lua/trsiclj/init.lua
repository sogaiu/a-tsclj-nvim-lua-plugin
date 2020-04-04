TrSi = {}

local default_query = [[
(ERROR) @Error

"(" @Delimiter
")" @Delimiter
"[" @Delimiter
"]" @Delimiter
"{" @Delimiter
"}" @Delimiter

(comment) @Comment
(discard_form) @SpecialChar

(metadata) @SpecialChar

(boolean) @Boolean
(character) @Character
(keyword) @Keyword
(nil) @Constant
(number) @Number
(regular_expression) @Constant 
(string) @String

((list
    value: (symbol) @Conditional)
 (match? @Conditional "^(case|cond|if|if-let|if-not|when|when-let|when-not)$"))

((list
    value: (symbol) @Define)
 (match? @Define "^(declare|def.*|fn|let|ns)$"))

((list
    value: (symbol) @Exception)
 (match? @Exception "^(assert|catch|finally|throw|try)$"))

((list
    value: (symbol) @Repeat)
 (match? @Repeat "^(do|for|loop|recur)$"))

((vector
    value: (symbol) @Identifier))

((deref_form
    "@" @SpecialChar))

((quote_form
    "'" @SpecialChar))

((syntax_quote_form
    "`" @SpecialChar))

((unquote_form
    "~" @SpecialChar))

((unquote_splicing_form
    "~@" @SpecialChar))

((var_quote_form
    "#'" @SpecialChar))
]]

function TrSi:has_parser(lang)
  local path_pat = 'parser/' .. lang .. '.*'
  local check = #vim.api.nvim_get_runtime_file(path_pat, false) > 0
  if check then
    print("tree-sitter-" .. lang .. " detected")
  else
    print("tree-sitter-" .. lang .. " NOT detected")
  end
  return check
end

function TrSi:init_parser(lang)
  self.lang = lang
  self.parser = nil
  if self:has_parser(lang) then
    -- XXX: should there be platform detection (dll, dynlib, so)?
    local path_pat = 'parser/' .. lang .. '.*'
    local lang_path = vim.api.nvim_get_runtime_file(path_pat, false)[1]
    -- XXX: how to check for failure?
    vim.treesitter.require_language(lang, lang_path)
    self.parser = vim.treesitter.get_parser(0, lang)
  end
  if not self.parser then
    print("failed to initialize parser")
  end
  return self.parser
end

function TrSi:highlight_clojure(query, bufnr)
  if not self.parser then
    local parser = TrSi:init_parser("clojure")
    if not parser then
      return nil
    end
  end
  if self.lang ~= "clojure" then
    print("parser was not initialized for clojure")
    return nil
  end
  bufnr = bufnr or 0
  query = query or default_query
  if not self.highlighter then
    self.highlighter = vim.treesitter.TSHighlighter.new(query,
                                                        bufnr,
                                                        "clojure")
  else
    self.highlighter:set_query(query)
  end
  return self.highlighter
end

return TrSi
