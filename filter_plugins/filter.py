from ansible import errors

def split(string, char):
    try:
        return string.split(char)
    except Exception, e:
        raise errors.AnsibleFilterError('split plugin error: %s' % str(e) )

class FilterModule(object):
    ''' A filter to split a string into a list. '''
    def filters(self):
        return {
            'split' : split
        }
