# Fixing sassc Installation Issues

The `sassc` gem requires native C extensions. Here's how to fix the installation error on different systems:

## macOS

```bash
# Install Xcode Command Line Tools (if not already installed)
xcode-select --install

# If you're using Homebrew, install libffi
brew install libffi

# Then try bundle install again
bundle install
```

If you still have issues on macOS with Apple Silicon (M1/M2/M3):
```bash
# Set architecture flags
bundle config build.sassc --with-ffi-dir=$(brew --prefix libffi)
bundle install
```

## Linux (Ubuntu/Debian)

```bash
# Install build tools and dependencies
sudo apt-get update
sudo apt-get install -y build-essential libffi-dev

# Then try bundle install again
bundle install
```

## Linux (CentOS/RHEL/Fedora)

```bash
# Install build tools and dependencies
sudo yum groupinstall "Development Tools"
sudo yum install libffi-devel

# Or on Fedora
sudo dnf install @development-tools libffi-devel

# Then try bundle install again
bundle install
```

## Windows

On Windows, you'll need:

1. Install Ruby with DevKit from https://rubyinstaller.org/
2. Run `ridk install` in a new terminal
3. Select option 3 (MSYS2 and MINGW development toolchain)
4. Then run `bundle install`

## Alternative Solution: Use Precompiled Gem

If native compilation continues to fail, you can try using a platform-specific precompiled version:

```bash
# Remove existing installation attempts
bundle pristine sassc

# Or force platform-specific gem
gem install sassc --platform=ruby
bundle install
```

## Last Resort: Use Tailwind CSS Instead

If you continue having issues with sassc, you can replace it entirely with Tailwind CSS (modern approach):

```bash
# Remove sassc dependencies
bundle remove sass-rails sassc-rails

# Add Tailwind
bundle add tailwindcss-rails
rails tailwindcss:install
```

## After Successful Installation

Once `bundle install` succeeds, run the database migrations:

```bash
rails db:create
rails db:migrate
```

Then start your server:
```bash
rails server
```

## Need Help?

If you're still stuck, please share:
1. Your operating system (macOS, Linux distro, Windows)
2. Ruby version: `ruby -v`
3. Full error output from `bundle install`
