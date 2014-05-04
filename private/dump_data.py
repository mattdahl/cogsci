import subprocess
import re
from datetime import datetime

# Writing regex in bash is a pain... so, python script instead
mongodb_connection_template = re.compile(r'mongodb://(?P<user>.+?):(?P<password>.+?)@(?P<host>.+?)\/(?P<db>.+)')

meteor_url = subprocess.check_output(['meteor', 'mongo', '--url', 'cogsci.meteor.com'])
connection_data = mongodb_connection_template.match(meteor_url).groupdict()

subprocess.call(['mongoexport',
	'-u', connection_data['user'],
	'-p', connection_data['password'],
	'-h', connection_data['host'],
	'-db', connection_data['db'],
	'--collection', 'responses',
	'-o', 'cogsci_data_' + datetime.now().isoformat()
])

exit()