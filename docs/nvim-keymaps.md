#  کیبایندینگ‌های Neovim

> راهنمای کامل کلیدهای میانبر Nvim — به ترتیب گروه

---

##  نکات عمومی

| کلید | کار | پلاگین |
|---|---|---|
| `<Space>` | Leader key | Native |
| `jk` | خروج از حالت درج (Insert) | Native |
| `<Esc>` | پاک کردن هایلایت جستجو | Native |
| `j` / `k` | حرکت در خطوط طولانی (wrap-aware) | Native |
| `<C-d>` / `<C-u>` | نیم صفحه پایین/بالا (وسط‌شده) | Native |
| `n` / `N` | نتیجه بعدی/قبلی جستجو (وسط‌شده) | Native |
| `s` | پرش سریع به هر نقطه صفحه | mini.jump2d |

---

##  پنجره‌ها `<leader>w`

| کلید | کار | پلاگین |
|---|---|---|
| `<C-h/j/k/l>` | جابجایی بین پنجره‌ها | Native |
| `<leader>wv` | تقسیم عمودی | Native |
| `<leader>ws` | تقسیم افقی | Native |
| `<leader>wq` | بستن پنجره | Native |
| `<leader>wo` | بستن بقیه پنجره‌ها | Native |
| `<C-↑/↓>` | تغییر ارتفاع پنجره | Native |
| `<C-←/→>` | تغییر عرض پنجره | Native |

---

##  بافرها `<leader>b`

| کلید | کار | پلاگین |
|---|---|---|
| `<S-h>` / `<S-l>` | بافر قبلی/بعدی | Native |
| `<leader>bb` | بافر جایگزین (alternate) | Native |
| `<leader>bn` / `bp` | بافر بعدی/قبلی | bufferline |
| `<leader>bd` | بستن بافر | mini.bufremove |
| `<leader>bD` | بستن اجباری بافر | mini.bufremove |
| `<leader>bo` | بستن بقیه بافرها | Native |

---

##  فایل و جستجو `<leader>f`

| کلید | کار | پلاگین |
|---|---|---|
| `<leader><space>` | جستجوی هوشمند | Snacks |
| `<leader>/` | جستجوی متن (Grep) | Snacks |
| `<leader>ff` | پیدا کردن فایل | Snacks |
| `<leader>fg` | فایل‌های Git | Snacks |
| `<leader>fr` | فایل‌های اخیر | Snacks |
| `<leader>fb` | لیست بافرها | Snacks |
| `<leader>fh` | راهنمای Neovim | Snacks |
| `<leader>fk` | لیست کیبایندینگ‌ها | Snacks |
| `<leader>fc` | لیست دستورات | Snacks |
| `<leader>fp` | لیست پروژه‌ها | Snacks |
| `<leader>fs` | نمادهای فایل فعلی (LSP) | Snacks |
| `<leader>fS` | نمادهای کل پروژه (LSP) | Snacks |
| `<leader>fw` | جستجوی کلمه زیر نشانگر | Snacks |
| `<leader>fd` | دیاگنوستیک فایل فعلی | Snacks |
| `<leader>fD` | دیاگنوستیک کل پروژه | Snacks |

---

##  اکسپلورر `<leader>e`

| کلید | کار | پلاگین |
|---|---|---|
| `<leader>ee` | باز کردن اکسپلورر | Snacks |
| `<leader>ef` | اکسپلورر در مسیر فایل فعلی | Snacks |
| `<leader>ey` | باز کردن Yazi در tmux | Snacks |

---

##  گیت `<leader>g`

| کلید | کار | پلاگین |
|---|---|---|
| `<leader>gg` | باز کردن Lazygit شناور | Snacks |
| `<leader>gl` | تاریخچه کامیت‌ها (Log) | Snacks |
| `<leader>gf` | تاریخچه فایل فعلی | Snacks |
| `<leader>go` | باز کردن در مرورگر | Snacks |
| `<leader>gb` | لیست برنچ‌ها | Snacks |
| `<leader>gS` | وضعیت فایل‌های تغییر کرده | Snacks |
| `]h` / `[h` | hunk بعدی/قبلی | Gitsigns |
| `<leader>gs` | افزودن hunk به staging | Gitsigns |
| `<leader>gr` | بازگرداندن hunk | Gitsigns |
| `<leader>gA` | افزودن کل فایل به staging | Gitsigns |
| `<leader>gR` | بازگرداندن کل فایل | Gitsigns |
| `<leader>gp` | پیش‌نمایش hunk | Gitsigns |
| `<leader>gB` | مقصر خط فعلی (Blame) | Gitsigns |
| `<leader>gt` | نمایش/مخفی کردن blame خطی | Gitsigns |
| `<leader>gd` | مقایسه فایل فعلی با نسخه قبل | Gitsigns |
| `<leader>gD` | مقایسه فایل فعلی با HEAD~ | Gitsigns |
| `<leader>tx` | نمایش خطوط حذف‌شده | Gitsigns |

---

##  LSP `<leader>l`

| کلید | کار | پلاگین |
|---|---|---|
| `gd` | رفتن به تعریف | LSP |
| `gD` | رفتن به declaration | LSP |
| `gr` | رفتن به مراجع | LSP |
| `gI` | رفتن به implementation | LSP |
| `K` | نمایش مستندات (Hover) | LSP |
| `<leader>lk` | نمایش پارامترهای تابع | LSP |
| `<leader>lr` | تغییر نام نماد | LSP |
| `<leader>la` | اقدام کد (Code Action) | LSP |
| `<leader>lf` | فرمت کردن فایل | LSP |
| `<leader>li` | اطلاعات LSP | LSP |

---

##  دیاگنوستیک `<leader>d`

| کلید | کار | پلاگین |
|---|---|---|
| `]d` / `[d` | دیاگنوستیک بعدی/قبلی | LSP |
| `<leader>dd` | نمایش دیاگنوستیک خط فعلی | LSP |
| `<leader>dq` | ارسال دیاگنوستیک‌ها به Quickfix | LSP |

---

##  کد و ادیت `<leader>c`

| کلید | کار | پلاگین |
|---|---|---|
| `<leader>cR` | تغییر نام فایل | Snacks |
| `<leader>cw` | حذف فاصله‌های اضافی انتهای خط | mini.trailspace |
| `gsa` | افزودن surround | mini.surround |
| `gsd` | حذف surround | mini.surround |
| `gsr` | جایگزینی surround | mini.surround |
| `gsh` | هایلایت surround | mini.surround |
| `gsj` | تقسیم/ادغام خطوط | mini.splitjoin |
| `<M-h/j/k/l>` | جابجایی خطوط/بلوک‌ها | mini.move |
| `gc` / `gcc` | کامنت کردن | mini.comment |

---

##  اجرا / REPL `<leader>r`

| کلید | کار | پلاگین |
|---|---|---|
| `<leader>rp` | باز کردن IPython در tmux | vim-slime |
| `<leader>rl` | ارسال خط فعلی به REPL | vim-slime |
| `<leader>rs` | ارسال انتخاب به REPL | vim-slime |
| `<leader>rc` | ارسال سلول فعلی به REPL | vim-slime |
| `<leader>rf` | ارسال کل فایل به REPL | vim-slime |
| `]c` / `[c` | سلول بعدی/قبلی (Python) | vim-slime |

---

##  تب‌ها `<leader>t`

| کلید | کار | پلاگین |
|---|---|---|
| `<leader>tn` | تب جدید | Native |
| `<leader>tc` | بستن تب | Native |
| `<leader>to` | بستن بقیه تب‌ها | Native |
| `<leader>tl` / `th` | تب بعدی/قبلی | Native |
| `]T` / `[T` | تب بعدی/قبلی | Native |

---

##  ترمینال `<leader>t`

| کلید | کار | پلاگین |
|---|---|---|
| `<leader>tt` | ترمینال شناور | Snacks |
| `<leader>tf` | ترمینال در پایین صفحه | Snacks |
| `<Esc><Esc>` | خروج از حالت ترمینال | Native |
| `<C-h/j/k/l>` | جابجایی از ترمینال به پنجره‌ها | Native |

---

##  تنظیمات نمایش `<leader>u`

| کلید | کار | پلاگین |
|---|---|---|
| `<leader>uz` | حالت تمرکز (Zen) | Snacks |
| `<leader>un` | بستن نوتیفیکیشن‌ها | Snacks |
| `<leader>ui` | نمایش/مخفی راهنمای تورفتگی | Snacks |
| `<leader>us` | اسکرول نرم | Snacks |
| `<leader>uw` | هایلایت کلمات مشابه | Snacks |
| `<leader>ud` | نمایش/مخفی دیاگنوستیک‌ها | Snacks |
| `<leader>ul` | شماره خطوط نسبی | Native |
| `<leader>uw` | شکستن خطوط (Wrap) | Native |
| `<leader>us` | بررسی املا (Spell) | Native |

---

##  تکمیل خودکار (Insert Mode)

| کلید | کار | پلاگین |
|---|---|---|
| `<C-Space>` | نمایش تکمیل | blink.cmp |
| `<C-e>` | بستن منوی تکمیل | blink.cmp |
| `<C-j>` / `<C-k>` | حرکت در لیست تکمیل | blink.cmp |
| `<C-d>` / `<C-u>` | اسکرول مستندات | blink.cmp |
| `<Tab>` / `<S-Tab>` | انتخاب / جابجایی | blink.cmp |

---

##  پرانتز و براکت (Insert Mode)

| کلید | کار | پلاگین |
|---|---|---|
| `(` / `)` | بستن خودکار | mini.pairs |
| `{` / `}` | بستن خودکار | mini.pairs |
| `[` / `]` | بستن خودکار | mini.pairs |
| `"` / `'` | بستن خودکار | mini.pairs |

---

##  جابجایی بین بخش‌های کد (mini.bracketed)

| کلید | کار | پلاگین |
|---|---|---|
| `]b` / `[b` | بافر بعدی/قبلی | mini.bracketed |
| `]c` / `[c` | کامنت بعدی/قبلی | mini.bracketed |
| `]d` / `[d` | دیاگنوستیک بعدی/قبلی | mini.bracketed |
| `]f` / `[f` | فایل بعدی/قبلی | mini.bracketed |
| `]i` / `[i` | تورفتگی بعدی/قبلی | mini.bracketed |
| `]j` / `[j` | پرش بعدی/قبلی | mini.bracketed |
| `]l` / `[l` | موقعیت بعدی/قبلی | mini.bracketed |
| `]o` / `[o` | فایل اخیر بعدی/قبلی | mini.bracketed |
| `]q` / `[q` | Quickfix بعدی/قبلی | mini.bracketed |
| `]t` / `[t` | Treesitter بعدی/قبلی | mini.bracketed |
| `]u` / `[u` | Undo بعدی/قبلی | mini.bracketed |
| `]w` / `[w` | پنجره بعدی/قبلی | mini.bracketed |
| `]y` / `[y` | یانک بعدی/قبلی | mini.bracketed |

---

##  فرمت و لینت

| کلید | کار | پلاگین |
|---|---|---|
| `<leader>lf` | فرمت فایل فعلی | conform.nvim |

فرمت هنگام ذخیره خودکار فعال است (conform.nvim).

---

##  راهنمای گروه‌ها

| پیشوند | گروه | پلاگین اصلی |
|---|---|---|
| `<leader>b` | بافرها | bufferline + mini.bufremove |
| `<leader>c` | کد و ادیت | Snacks + mini.* |
| `<leader>d` | دیاگنوستیک | LSP |
| `<leader>e` | اکسپلورر | Snacks |
| `<leader>f` | جستجو و فایل | Snacks |
| `<leader>g` | گیت | Gitsigns + Snacks |
| `<leader>l` | LSP | LSP + conform |
| `<leader>m` | مارک‌داون | (آینده) |
| `<leader>r` | اجرا / REPL | vim-slime |
| `<leader>t` | تب و ترمینال | Native + Snacks |
| `<leader>u` | تنظیمات نمایش | Snacks + Native |
| `<leader>w` | پنجره‌ها | Native |
