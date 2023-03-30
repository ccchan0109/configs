This is my personal config files in Linux.

See usage by
./x.sh -h

## Work with submodules

To clone submodules, run
```bash
git submodule update --init --recursive
```

or, clone this project with flag `--recurse-submodules`, then the submodules will be cloned simultaneously.
```bash
git clone --recurse-submodules git@github.com:ccchan0109/configs.git
```

If you want to update all submodules in your repository to their latest commits, run
```bash
git submodule update --remote
```
This will fetch the latest commits for each submodule and update them to the latest commit on the branch they are tracking.
