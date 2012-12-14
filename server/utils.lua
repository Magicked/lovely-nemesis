-- Remove any final \n from a string.
--   s: string to process
-- returns
--   s: processed string
function chomp(s)
    return string.gsub(s, "\n$", "")
end