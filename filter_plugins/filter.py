from ansible import errors

def split(string, char):
    try:
        return string.split(char)
    except Exception, e:
        raise errors.AnsibleFilterError('split plugin error: %s' % str(e) )

def do_slice(value, items_per_slice):
    seq = list(value)
    length = len(seq)
    slices = -(-length // items_per_slice)
    for slice_number in range(slices):
        start = slice_number * items_per_slice
        end = (slice_number + 1) * items_per_slice
        yield seq[start:end]

class FilterModule(object):
    ''' A filter to split a string into a list. '''
    def filters(self):
        return {
            'split' : split,
            'slice2': do_slice
        }
