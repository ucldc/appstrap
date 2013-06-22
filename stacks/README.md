# Stacks

Stack up your app!

## `stack_*`
  The `stack_*` scripts install the base packages, code, and configuration
  needed to deploy an application.

## `*.pkgsrc.txt`
  A list of pkgsrc packages that need to be installed for this stack.
Right now this is used on the EC2s as well as SUSEs; switch to `yum` for EC2?

## `*.pip.txt`
  A list of python packages that need to be installed.  Replace with
`pip install -r requirements.txt` style file?

## `*.cpanm.txt`
  A list of perl packages to be installed with CPAN Minus.

Not every stack will have all the `*.*.txt` package files.
