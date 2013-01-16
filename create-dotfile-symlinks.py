#!/usr/bin/env python

import os
import sys
import time

class Create_Dotfile_Symlinks:

    '''
    @author Chris Laskey
    @updated 2013.01.16
    @version 0.4.4

    A simple script to setup a user's home directory by creating symbolic links
    in the home directory that link to the dot files in the git repository.
    This allows dot files to be managed in a git repo, making it easier to
    update and keep a uniform environment across machines and/or users.

    Any file that begins with a period inside the git repository will have
    a link created in the user's home directory. Files can be excluded
    using the self.excludedfiles list variable below. Sensible defaults are
    included like .git, .gitignore and .DS_Store.

    The script will not delete current dot files. If a file already exists, the
    original file is backed up in the home directory in a directory named
    ".dot-files-backup-YYYYMMDD."

    This script is idempotent, so re-running it is encouraged to ensure new
    files are up to date.
    '''

    def __init__(self):
        self.verify_python_version()
        self.set_environment_variables()
        self.create_symlinks()

    def verify_python_version(self):
        if sys.version_info[0] == 2 and sys.version_info[1] < 4:
            print('Error: Script requires Python version >= 2.4')
            sys.exit(1)

    def set_environment_variables(self):
        argc = len(sys.argv)
        self.sourcedir = sys.argv[1] if argc >= 2 else '~/.dot-files'
        self.targetdir = sys.argv[2] if argc >= 3 else '~'
        self.sourcedir = os.path.abspath(os.path.expanduser(self.sourcedir))
        self.targetdir = os.path.abspath(os.path.expanduser(self.targetdir))
        self.excludedfiles = ['.git', '.gitignore', '.DS_Store']

    def create_symlinks(self):
        '''
        Create symlinks if needed and log it to stdout. If a correct
        symlink already exists, log it to stdout and continue.
        '''
        dot_items = self._return_dot_items()
        for item in dot_items:

            # Set variables
            target = os.path.join(self.targetdir, item)
            backupdir = os.path.join(self.targetdir,
                '.dot-files-backup-%s' % (time.strftime('%Y%m%d')))
            backup = os.path.join(self.targetdir,
                '.dot-files-backup-%s' % (time.strftime('%Y%m%d')),
                '%s' % (item))
            source = os.path.join(self.sourcedir, item)

            # Don't do anything if is symlink and points to the right location
            if os.path.islink(target) and \
                self._symlink_absolute_path(target) == source:
                print('Correct symlink already exists for %s' % (target))
                continue

            # Backup any already existing files
            if os.path.exists(target):
                self._create_backup_dir(backupdir)
                try:
                    os.rename(target, backup)
                    print('Renamed %s to %s' % (target, backup))
                except Exception:
                    print('Error moving existing file "%s"' % (target))

            # Create symlinks
            try:
                os.symlink(source, target)
                print('Created symlink from %s to %s' % (target, source))
            except Exception:
                print('Error creating symlink from %s to %s' % \
                    (target, source))

    def _return_dot_items(self):
        '''Return files that begin with a . in the source directory.'''
        dot_items = []
        for item in os.listdir(self.sourcedir):
            path = os.path.join(self.sourcedir, item)
            if item[0] is '.' and \
                not os.path.islink(path) and \
                item not in self.excludedfiles:
                dot_items.append(item)
        return dot_items

    def _create_backup_dir(self, backupdir):
        '''Utility function to create backup directory if needed.'''
        if not os.path.exists(backupdir):
            try:
                os.mkdir(backupdir)
                print('Created backup folder %s' % (backupdir))
            except Exception:
                print('Error creating backup folder %s' % (backupdir))

    def _symlink_absolute_path(self, link):
        '''
        Utility function that returns a symlink target as an absolute path.
        This is important since os.readlink does not always return an abs path.

        Thanks to Greg Smith.
        http://notemagnet.blogspot.com/2009/09/following-symlinks-in-python.html
        '''
        assert (os.path.islink(link))
        path = os.path.normpath(os.readlink(link))
        if os.path.isabs(path):
            return path
        return os.path.join(os.path.dirname(link), path)

if __name__ == "__main__":
    Create_Dotfile_Symlinks()
else:
    print('Error: Command line support only')
    sys.exit(1)
