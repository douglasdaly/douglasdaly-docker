# -*- coding: utf-8 -*-
"""
configure.py

    Configures everything for building and deploying
    these docker images.

@author: Douglas Daly
@date: 10/20/2018
"""
#
#   Imports
#
import os

import click
import dotenv


#
#   Variables to set
#

to_set = {
    'VERSION_TAG': (None, False),
    'DEPLOYMENT_TYPE': (['AWS'], False)
}

aws_options = {
    'AWS_REGION': (None, False),
    'DOCKER_REGISTRY': (None, False)
}


#
#   Load Env
#

conf_file = '.env-conf'
hidden_file = '.env'


#
#   Functions
#

def _prompt(key, default_value=None, options=None, hide_input=False):
    """Prompts user for input"""
    text = key
    curr_value = os.environ.get(key, default_value)

    if options is not None:
        text += "\n"
        for i_opt in range(len(options)):
            text += " ({}) {}\n".format(i_opt+1, options[i_opt])

    if curr_value is not None:
        if hide_input:
            text += "[{}]".format("*" * len(curr_value))

    user_in = click.prompt(text, default=curr_value, hide_input=hide_input,
                           show_default=(not hide_input))

    if options is not None:
        try:
            user_in = options[int(user_in) - 1]
        except Exception:
            pass

    return user_in


def _initialize_envs(just_init_files=False):
    """Initializes environment files (if they don't exist)"""
    if not os.path.exists(conf_file):
        f = open(conf_file, 'w+')
        f.close()

    if not os.path.exists(hidden_file):
        f = open(hidden_file, 'w+')
        f.close()

    if not just_init_files:
        dotenv.load_dotenv(conf_file)
        dotenv.load_dotenv(hidden_file)


def _prompt_dictionary(dict_to_prompt):
    """"""
    ret = dict()
    for k, (def_v, hide_input) in dict_to_prompt.items():
        if isinstance(def_v, (list, tuple)):
            def_val = os.environ.get(k, def_v[0])
            res = _prompt(k, options=def_v, default_value=def_val,
                          hide_input=hide_input)
        else:
            res = _prompt(k, default_value=def_v, hide_input=hide_input)
        ret[k] = res
    return ret


@click.command()
def main():
    """Main script function"""
    step_1_dict = _prompt_dictionary(to_set)

    all_opts = step_1_dict.copy()
    if step_1_dict['DEPLOYMENT_TYPE'] == 'AWS':
        step_2_dict = _prompt_dictionary(aws_options)
        all_opts.update(step_2_dict)

    print("\nValues to Set:")
    for k, v in all_opts.items():
        print("  {}: {}".format(k, v))

    res = click.confirm("Save these values?")
    if res:
        # - Remove old files
        os.remove(hidden_file)
        os.remove(conf_file)
        _initialize_envs(True)
        for k, v in all_opts.items():
            if k in to_set.keys():
                dotenv.set_key(conf_file, k, v, quote_mode="never")
            dotenv.set_key(hidden_file, k, v, quote_mode="never")


#
#   Script Entry-point
#

if __name__ == "__main__":
    """Entry-point"""
    _initialize_envs()
    main()
