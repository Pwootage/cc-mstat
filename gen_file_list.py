import os
import re

def main():
  ignore_list = [
    'gen_file_list.py',
    '.file-list',
    'README.md',
    '^\\.',
  ]

  file_list = []
  for root, dirs, files in os.walk('.', topdown = True):
    for name in files:
      fullname = os.path.join(root, name)
      fullname = fullname[2:].replace('\\', '/')
      # print(name)
      #  if not regex match
      if not any([re.match(ignore, name) or re.match(ignore, fullname) for ignore in ignore_list]):
        print("Adding file: {}".format(fullname))
        file_list.append(fullname)

  with open('.filelist', 'w') as f:
    f.write('\n'.join(file_list))

if __name__ == '__main__':
  main()