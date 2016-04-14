import csv


strings = [
    'cpu',
    'model',
    'cpu-model',
    'processor-model',
    'gpu',
    'configurable',
    'os',
    'memory-type',
    'colors',
]

floats = [
    'price',
    'screen-size',
    'weight',
    'battery-life',
    'processor-speed',
    'cpu-class'
    'gpu-class'
]


def row_to_dict(header, line):
    d = {}

    for i, key in enumerate(header):
        d[key] = line[i]

    return d


def slot(key, value):
    if value.strip() is '':
        return ''

    if key in strings:
        value = '"' + value + '"'

    if key in floats:
        value = "%0.2f" % float(value)

    return '(' + key + ' ' + value + ') '


def row_to_clps(header, line):
    d = row_to_dict(header, line)
    clps = '(laptop '

    for k, v in d.items():
        clps += slot(k, v)

    clps += ')'
    return clps


with open('data.csv', 'r') as f:
    csv_reader = csv.reader(f, delimiter=',')
    header = next(csv_reader)

    clp_outfile = open('laptop-features.clp', 'w')
    clp_outfile.write('(deffacts initial ')

    for line in csv_reader:
        clp_outfile.write(row_to_clps(header, line))
        clp_outfile.write('\n')

    clp_outfile.write(')')
    clp_outfile.close()
