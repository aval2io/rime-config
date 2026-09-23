-- 中文模式下，输入单个数字的拼音时，在第二个候选位给出对应的罗马数字
-- 例：输入 er → 候选 1「二」，候选 2「Ⅱ」；输入 shi → 「十」+「Ⅹ」
-- 仅处理单个数字（一至十），不考虑 shier 之类的多音节组合

local map = {
    yi  = "Ⅰ",
    er  = "Ⅱ",
    san = "Ⅲ",
    si  = "Ⅳ",
    wu  = "Ⅴ",
    liu = "Ⅵ",
    qi  = "Ⅶ",
    ba  = "Ⅷ",
    jiu = "Ⅸ",
    shi = "Ⅹ",
}

local function roman_numeral_filter(input, env)
    local context = env.engine.context
    -- 英文模式（ascii_mode）下直接放行，不插入罗马数字
    -- 注意：本机 Squirrel 的 librime-lua 没有 context:get_ascii_mode()，用 get_option 代替
    local roman = (not context:get_option("ascii_mode")) and map[context.input]
    local first = true

    for cand in input:iter() do
        yield(cand)
        if first then
            first = false
            if roman then
                local segment = context.composition:back()
                if segment then
                    -- 本机 librime-lua 较旧：Segment 起点字段是 start（新版为 start_pos）
                    yield(Candidate("roman", segment.start, segment._end, roman, ""))
                end
            end
        end
    end
end

return roman_numeral_filter
