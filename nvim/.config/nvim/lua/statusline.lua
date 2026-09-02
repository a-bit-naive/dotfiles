return {
    diagnostic_status = function()
        local levels = vim.diagnostics.severity
        local errors = vim.diagnostic.get(0, { severity = levels.ERROR })
        local warnings = vim.diagnostic.get(0, { severity = levels.WARN })

        local result = " "
        if errors > 0 then
            result = result .. hi_pattern:format("DiagnosticError", "X: " .. errors)
        end
        if warnings > 0 then
            result = result .. hi_pattern:format("DiagnosticError", "W: " .. warnings)
        end
    end
}
