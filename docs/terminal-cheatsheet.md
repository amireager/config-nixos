# 🚀 راهنمای کاربردی ابزارهای ترمینال

> چیت‌شیت عملی ابزارهایی که توی این سیستم نصبه. هر بخش: «این چیه + چند دستور پرکاربرد».
> برای دیدن لیست کامل گزینه‌های هر ابزار: `tldr <اسم ابزار>` یا `<ابزار> --help`.

---

## 📂 فایل و دایرکتوری

### `eza` — جایگزین `ls`

الیاس‌ها از قبل توی fish تنظیم شدن:

```fish
ls            # eza با آیکون، گروه‌بندی پوشه‌ها، وضعیت git
ll            # لیست بلند + هدر
la            # شامل فایل‌های مخفی
lt            # درخت تا عمق ۲
tree          # درخت کامل
```

### `yazi` — فایل‌منیجر کامل ترمینال (کلید: `y`)

```fish
y             # باز کردن yazi در مسیر فعلی (موقع خروج، cd می‌کنه همون‌جا)
```

داخلش: `j/k` بالا‌پایین، `l` ورود، `h` برگشت، `Space` انتخاب، `y` کپی، `p` پیست، `d` حذف، `/` جستجو، `q` خروج.

### `broot` — ناوبری درختی تعاملی (کلید: `br`)

```fish
br            # درخت تعاملی؛ تایپ کن تا فیلتر شه، Enter وارد شو
```

### `zoxide` — جایگزین هوشمند `cd` (کلید: `z`)

```fish
z proj        # پرش به پرتکرارترین مسیری که «proj» داره
zi            # انتخاب تعاملی از مسیرهای قبلی
```

هرچی بیشتر استفاده کنی، باهوش‌تر می‌شه.

---

## 🔍 جستجو

### `ripgrep` (`rg`) — جایگزین `grep`

```fish
rg "TODO"               # جستجوی متن در کل پروژه (با احترام به .gitignore)
rg -i pattern           # بدون حساسیت به بزرگی/کوچکی حروف
rg -l pattern           # فقط اسم فایل‌های مطابق
rg pattern -t nix       # فقط فایل‌های nix
```

### `fd` — جایگزین `find`

```fish
fd config               # هر فایل/پوشه با «config» در اسم
fd -e nix               # همه‌ی فایل‌های .nix
fd -H secret            # شامل فایل‌های مخفی
fd pattern -x rm        # روی هر نتیجه دستور اجرا کن (احتیاط!)
```

### `fzf` — فازی‌فایندر همه‌کاره

```fish
# داخل fish اینا فعالن:
Ctrl-T        # انتخاب فازی فایل و درج در خط فرمان
Alt-C         # cd فازی به یک پوشه
Ctrl-R        # جستجوی فازی تاریخچه (با atuin جایگزین شده، پایین‌تر)
```

ترکیب قدرتمند: `nvim (fzf)` ، `cat (fzf)`.

---

## 📄 محتوای فایل

### `bat` — جایگزین `cat`

```fish
cat file.nix            # (الیاس) نمایش با هایلایت سینتکس
bat -A file             # نمایش کاراکترهای نامرئی (tab/space)
bat file1 file2         # چند فایل پشت سر هم
```

### `sd` — جایگزین `sed` برای جایگزینی متن

```fish
sd 'foo' 'bar' file.txt        # جایگزینی در فایل
sd -p 'foo' 'bar' file.txt     # فقط پیش‌نمایش تغییرات (preview)
fd -e nix -x sd 'old' 'new'    # جایگزینی در همه‌ی فایل‌های nix
```

---

## 📊 مانیتورینگ و سیستم

### `btop` — مانیتور اصلی منابع (CPU/RAM/دیسک/شبکه)

```fish
btop          # داشبورد زنده؛ با موس هم کار می‌کنه
# داخلش: f = فیلتر، Enter = جزئیات پردازه، k = kill، q = خروج
```

### `nvtop` — مانیتور کارت گرافیک (GPU)

```fish
nvtop         # نمودار زنده‌ی مصرف GPU و حافظه‌ی ویدئو
```

### `procs` — جایگزین `ps`

```fish
procs                   # لیست رنگی پردازه‌ها
procs firefox           # فیلتر بر اساس نام
procs --sortd mem       # مرتب بر اساس مصرف حافظه (نزولی)
procs --tree            # نمای درختی سلسله‌مراتب پردازه‌ها
```

### `fastfetch` — اطلاعات سیستم

```fish
fastfetch     # لوگو + مشخصات سیستم (برای اسکرین‌شات/چک سریع)
```

---

## 💾 دیسک

### `dust` — جایگزین `du`

```fish
dust          # درخت رنگی مصرف فضا، مرتب‌شده بر اساس حجم
dust -d 2     # محدود به عمق ۲
dust -r       # برعکس (بزرگ‌ترین پایین)
```

### `duf` — جایگزین `df`

```fish
duf           # نمای زیبای پارتیشن‌ها و فضای آزاد
```

---

## 🌳 گیت

### `git` (+ `delta` برای دیف رنگی)

الیاس/اَبر‌های fish:

```fish
gs            # git status
ga            # git add
gc "msg"      # git commit -m
gst           # git status --short --branch
gl            # لاگ گرافیکی
gp / gpl      # push / pull --rebase
```

الیاس‌های داخل خود git:

```fish
git st        # status کوتاه
git lg        # لاگ گرافیکی همه‌ی شاخه‌ها
git last      # آخرین کامیت + آمار
git amend     # اصلاح آخرین کامیت بدون تغییر پیام
git unstage <file>
```

### `lazygit` — رابط گرافیکی ترمینالی گیت

```fish
lazygit       # همه‌چیز ویژوال: stage با Space، commit با c، push با P
```

سریع‌ترین راه برای stage/commit/branch/rebase بدون حفظ‌کردن دستورها.

### `gh` — GitHub از ترمینال

```fish
gh repo clone user/repo
gh pr create            # ساخت Pull Request
gh pr list / gh pr checkout <n>
gh repo view --web      # باز کردن ریپو در مرورگر
```

---

## ⏱️ تاریخچه و بهره‌وری

### `atuin` — تاریخچه‌ی جادویی شل

```fish
Ctrl-R        # جستجوی فازی در کل تاریخچه (با پیش‌نمایش)
# تنظیم شده که Up arrow تاریخچه‌ی معمولی fish باشه، نه atuin
atuin stats   # آمار پرکاربردترین دستورها
```

### `just` — اجراکننده‌ی تسک (جای make)

یه فایل `justfile` کنار پروژه بساز:

```just
switch:
    sudo nixos-rebuild switch --flake .#nixos

update:
    nix flake update

fmt:
    nix fmt
```

بعد:

```fish
just            # لیست تسک‌ها
just switch     # اجرای تسک
```

### `tldr` (tealdeer) — چیت‌شیت دستورها

```fish
tldr tar        # مثال‌های کاربردی tar (بهتر از man برای یادآوری سریع)
tldr --update   # به‌روزرسانی دیتابیس
```

### `hyperfine` — بنچمارک دستور

```fish
hyperfine 'ls' 'eza'                 # مقایسه‌ی سرعت دو دستور
hyperfine -w 3 'my-command'          # با ۳ بار warmup
```

---

## 🪟 مالتی‌پلکسر — `tmux`

prefix روی `Ctrl-a` تنظیم شده (به‌جای پیش‌فرض Ctrl-b):

```fish
tmux                    # شروع نشست جدید
tmux new -s work        # نشست با نام
tmux ls                 # لیست نشست‌ها
tmux attach -t work     # اتصال مجدد
```

کلیدها (اول `Ctrl-a` بعد کلید):

```
|     تقسیم عمودی (پنل کنار هم)
-     تقسیم افقی (پنل بالا/پایین)
h j k l   جابه‌جایی بین پنل‌ها (ویم‌طور)
c     پنجره‌ی جدید
n / p تغییر پنجره‌ی بعدی/قبلی
r     ری‌لود کانفیگ
d     جدا شدن از نشست (detach)
```

---

## 🧊 ابزارهای Nix

```fish
nh os switch            # ریبیلد سیستم با خروجی زیبا (nh)
nvd diff /run/current-system result   # دیف نسل‌ها بعد از build
nix-tree                # کاوش درخت وابستگی‌ها
nix-init <url>          # ساخت اولیه‌ی پکیج از یک URL
, cowsay سلام           # اجرای برنامه بدون نصب دائمی (comma)
```

اَبرهای مفید fish (از ماژول ترمینال):

```fish
sw            # nixos-rebuild switch --flake .#nixos
nfu           # nix flake update
ngc           # پاک‌سازی نسل‌های قدیمی‌تر از ۱۴ روز
hms           # home-manager switch
```

---

## 💡 ترکیب‌های طلایی

```fish
# پیدا کن، با fzf انتخاب کن، با nvim باز کن
nvim (fd -e nix | fzf)

# جستجوی متن، پیش‌نمایش با bat
rg "function" -l | fzf --preview 'bat --color=always {}'

# بزرگ‌ترین پوشه‌ها رو پیدا کن
dust -d 1

# مقایسه‌ی سرعت دو راه‌حل
hyperfine 'grep -r x .' 'rg x'
```
