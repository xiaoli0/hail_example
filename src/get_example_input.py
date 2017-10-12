import os
if os.path.isdir('data/1kg.vds') and os.path.isfile('data/1kg_annotations.txt'):
    print('All files are present and accounted for!')
else:
    import sys
    sys.stderr.write('Downloading data (~50M) from Google Storage...\n')
    import urllib
    import tarfile
    urllib.urlretrieve('https://storage.googleapis.com/hail-1kg/tutorial_data.tar',
                       'tutorial_data.tar')
    sys.stderr.write('Download finished!\n')
    sys.stderr.write('Extracting...\n')
    tarfile.open('tutorial_data.tar').extractall()
    if not (os.path.isdir('data/1kg.vds') and os.path.isfile('data/1kg_annotations.txt')):
        raise RuntimeError('Something went wrong!')
    else:
        sys.stderr.write('Done!\n')
