#  راهنمای NixOS — مفاهیم و ابزارها

> چیزهایی که برای کار با NixOS باید بدونی

---

##  مفاهیم پایه

### Nix چیست؟
Nix یه **مدیر بسته تابعی** هست. هر بسته به صورت **ایزوله** نصب می‌شه و وابستگی‌هاش مستقل هستن. این یعنی:
- ❌ تعارض نسخه (dependency hell) نداری
- ❌ نصب خراب نمی‌شه
- ✅ می‌تونی به نسخه قبل برگردی (rollback)
- ✅ سیستم **قابل بازتولید** هست (declarative)

### NixOS چیست؟
NixOS یه توزیع لینوکس هست که **کل سیستم** با Nix مدیریت می‌شه. یعنی:
- همه چیز از یه فایل تنظیمات تعریف می‌شه (`configuration.nix`)
- سیستم قابل بازتولید هست
- می‌تونی کل سیستم رو از اول بسازی

### Flake چیست؟
Flake یه **ورودی قابل پیش‌بینی** برای Nix هست. مثل `package.json` ولی برای کل سیستم:
- `flake.nix` → تعریف ورودی‌ها و خروجی‌ها
- `flake.lock` → نسخه دقیق هر وابستگی (مثل `package-lock.json`)

### Home Manager چیست؟
Home Manager تنظیمات **سطح کاربر** رو مدیریت می‌کنه:
- پکیج‌های کاربر (نه سیستم)
- فایل‌های تنظیم (`.config/`)
- برنامه‌ها (`programs.*`)

---

##  ساختار پروژه ما

```
config-nixos/
├── flake.nix                    # نقطه ورود
├── hosts/nixos/
│   ├── configuration.nix       # تنظیمات سخت‌افزار
│   ├── core.nix                # تنظیمات پایه سیستم
│   ├── network.nix             # شبکه و پروکسی
│   └── hardware-configuration.nix
├── home/amir/
│   ├── default.nix             # نقطه ورود کاربر
│   ├── packages.nix            # پکیج‌ها
│   └── settings.nix            # تنظیمات برنامه‌ها
├── modules/
│   ├── desktop/                # دسکتاپ (Niri + DMS)
│   ├── editor/nvim/            # ویرایشگر
│   └── terminal/               # ترمینال و شل
└── docs/                       # مستندات
```

---

##  دستورات پایه Nix

### نصب و اجرا

| دستور | کار |
|---|---|
| `nix shell nixpkgs#برنامه` | اجرای موقت یه برنامه |
| `nix run nixpkgs#برنامه` | اجرا بدون نصب |
| `, برنامه` | اجرا بدون نصب (comma) |
| `nix profile install nixpkgs#برنامه` | نصب دائم |

### جستجو

| دستور | کار |
|---|---|
| `nix search nixpkgs متن` | جستجوی پکیج |
| `nix-env -qaP متن` | جستجوی پکیج (قدیمی) |
| `https://search.nixos.org/packages` | جستجوی وب |

### مدیریت Flake

| دستور | کار |
|---|---|
| `nix flake update` | آپدیت همه ورودی‌ها |
| `nix flake update dms` | آپدیت یه ورودی خاص |
| `nix flake lock` | فقط lock فایل رو آپدیت کن |
| `nix flake check` | بررسی فلیک |
| `nix flake metadata` | اطلاعات فلیک |

---

##  دستورات NixOS

### نوسازی سیستم

| دستور | کار |
|---|---|
| `sudo nixos-rebuild switch --flake .#nixos` | نوسازی و اعمال |
| `sudo nixos-rebuild test --flake .#nixos` | تست بدون اعمال |
| `sudo nixos-rebuild build --flake .#nixos` | فقط ساخت |
| `nh os switch` | نوسازی با nh (سریع‌تر) |
| `nh os switch -- -v` | نوسازی با خروجی کامل |

### مدیریت نسل‌ها

| دستور | کار |
|---|---|
| `nix profile history` | تاریخچه نسل‌ها |
| `nix profile diff-closures` | تفاوت نسل‌ها |
| `sudo nixos-rebuild list-generations` | لیست نسل‌ها |
| `sudo nix-env --delete-generations old` | حذف نسل‌های قدیمی |
| `nh clean all` | پاکسازی نسل‌های قدیمی |

### بررسی تغییرات

| دستور | کار |
|---|---|
| `nvd diff /run/current-system /nix/store/...` | مقایسه دو نسل |
| `nix diff-closures old new` | تفاوت حجم |

---

##  Home Manager

### دستورات

| دستور | کار |
|---|---|
| `home-manager switch --flake .#amir@nixos` | نوسازی تنظیمات کاربر |
| `nh home switch` | نوسازی با nh |
| `nh home build` | فقط ساخت |

### programs.* vs home.packages

| روش | کی استفاده بشه |
|---|---|
| `programs.برنامه.enable = true` | وقتی تنظیمات خاصی نیاز هست |
| `home.packages = [ pkgs.برنامه ]` | وقتی فقط نصب کافیه |

مثال:
```nix
# بهتر: تنظیمات مدیریت می‌شه
programs.git.enable = true;
programs.git.settings.user.name = "amir";

# ساده: فقط نصب
home.packages = [ pkgs.curl ];
```

---

##  ساختار فایل‌های Nix

### syntax پایه

```nix
# تعریف متغیر
let
  name = "amir";
  age = 25;
in {
  # attribute set
  user.name = name;
  user.age = age;
}

# تابع
{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    vim
    git
  ];
}
```

### import و with

```nix
# import: آوردن فایل دیگر
imports = [
  ./hardware.nix
  ./network.nix
];

# with: دسترسی سریع به attribute set
with pkgs; [ vim git curl ]
```

---

##  ابزارهای Nix

### nvd — مقایسه نسل‌ها
```bash
# بعد از rebuild، ببین چی عوض شده
nvd diff $(ls -d /nix/store/*-nixos-system-*-link | tail -2)
```

### nix-tree — درخت وابستگی
```bash
# ببین یه پکیج چیا رو نصب می‌کنه
nix-tree
```

### comma — اجرای بدون نصب
```bash
# هر برنامه‌ای رو بدون نصب اجرا کن
, cowsay "hello"
, python3 -c "print('hi')"
```

### nix-init — ساخت پکیج
```bash
# از URL یه بسته Nix بساز
nix-init https://github.com/user/repo
```

---

##  دیباگ و عیب‌یابی

### مشکل: پکیج پیدا نمی‌شه
```bash
# جستجو در nixpkgs
nix search nixpkgs نام_پکیج

# یا در وب
# https://search.nixos.org/packages
```

### مشکل: rebuild خطا می‌ده
```bash
# با verbose اجرا کن
nh os switch -- -v

# یا مستقیم
sudo nixos-rebuild switch --flake .#nixos --verbose
```

### مشکل: فضای دیسک کم شده
```bash
# ببین چقد فضا اشغال شده
nix store gc --dry-run

# پاکسازی
sudo nix-collect-garbage -d
nh clean all
```

### مشکل: نسخه قبلی بهتر بود
```bash
# برگشت به نسخه قبل
sudo nixos-rebuild switch --rollback

# یا انتخاب نسل خاص
sudo nix-env --switch-generation 42 -p /nix/var/nix/profiles/system
```

---

##  شبکه و پروکسی

### ساختار شبکه ما

```
اینترنت
    ↓
Dnscrypt-proxy (DNS رمزنگاری‌شده)
    ↓
ByeDPI (رد شدن از فیلتر)
    ↓
v2raya / sing-box (پروکسی)
    ↓
برنامه‌ها
```

### ابزارهای شبکه

| ابزار | کار |
|---|---|
| `doggo` | جستجوی DNS |
| `curl` | درخواست HTTP |
| `httpie` | درخواست HTTP (زیباتر) |
| `tcpdump` | بررسی بسته‌های شبکه |
| `nload` | نمایش ترافیک |
| `proxychains-ng` | اجرای برنامه از پروکسی |

### پروکسی

```bash
# اجرای برنامه از پروکسی
proxychains-ng curl https://example.com

# بررسی DNS
doggo example.com

# تست HTTP
http GET https://api.github.com
```

---

##  نکات مهم

### فایل‌های مهم

| فایل | کار |
|---|---|
| `flake.nix` | نقطه ورود، ورودی‌ها |
| `hosts/nixos/core.nix` | تنظیمات پایه سیستم |
| `hosts/nixos/network.nix` | شبکه و پروکسی |
| `home/amir/packages.nix` | پکیج‌های کاربر |
| `home/amir/settings.nix` | تنظیمات برنامه‌ها |
| `modules/desktop/` | دسکتاپ |

### قوانین ما

- همه چیز در `flake.nix` تعریف می‌شه
- پکیج‌های سیستم در `core.nix`
- پکیج‌های کاربر در `packages.nix`
- تنظیمات برنامه‌ها در `settings.nix`
- تنظیمات دسکتاپ در `modules/desktop/`

### rebuild بعد از تغییر

```bash
# تغییر در hosts/ → sudo nixos-rebuild
# تغییر در home/ → nh home switch
# تغییر در هر دو → nh os switch
```
