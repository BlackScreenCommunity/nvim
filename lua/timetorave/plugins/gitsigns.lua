local setup, gitsigns = pcall(require, "gitsigns")
if not setup then
  return
end

gitsigns.setup {
    current_line_blame = true,
    current_line_blame_opts = {
      virt_text = true,
      virt_text_pos = 'eol',
      delay = 500,
      ignore_whitespace = false,
      virt_text_priority = 100,
    }
}
