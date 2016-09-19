#!/usr/bin/env python
import os
import sys
import configparser
import json
import argparse

def read_aws_credentials_file(profile):
    aws = {}
    creds_file = configparser.ConfigParser()
    creds_file.read(os.environ['HOME'] + '/.aws/credentials')
    if profile in creds_file.sections():
        aws['access_key_id']     = creds_file.get(profile,'aws_access_key_id')
        aws['secret_access_key'] = creds_file.get(profile,'aws_secret_access_key')
        aws['session_token']     = creds_file.get(profile,'aws_session_token')
    else:
        print 'Invalid profile'
        sys.exit(1)
    return aws


def update_docker_machine_config_file(machine, aws_creds):
    config_file = '{0}/{1}/{2}/{3}'.format(os.environ['HOME'],
                                           '.docker/machine/machines',
                                           machine, 'config.json')
    if os.path.isfile(config_file):
        machine_config = json.load(open(config_file))
        machine_config['Driver']['AccessKey']    = aws_creds['access_key_id']
        machine_config['Driver']['SecretKey']    = aws_creds['secret_access_key']
        machine_config['Driver']['SessionToken'] = aws_creds['session_token']
        json.dump(machine_config, open(config_file,'w'))
    else:
        print 'Invalid machine'
        sys.exit(1)


def main(_profile, _machine):
    credentials = read_aws_credentials_file(_profile)
    update_docker_machine_config_file(_machine, credentials)


if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument('profile_name', help = 'aws profile w/ temp credentials')
    parser.add_argument('machine_name', help = 'aws docker machine in use')
    args = parser.parse_args()
    main(args.profile_name, args.machine_name)