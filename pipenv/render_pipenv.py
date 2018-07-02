import os
import jinja2


def render(tpl_path, context):
    path, filename = os.path.split(tpl_path)
    return jinja2.Environment(
        loader=jinja2.FileSystemLoader(path or './'),
        trim_blocks=True,
        lstrip_blocks=True
    ).get_template(filename).render(context)


if __name__ == '__main__':
    envs = {
        'windows_gpu':
            {
                'tmpl_flag_os': 'windows',
                'tmpl_flag_cuda': True
            },
        'windows_cpu':
            {
                'tmpl_flag_os': 'windows',
                'tmpl_flag_cuda': False
            },
        'linux_gpu':
            {
                'tmpl_flag_os': 'linux',
                'tmpl_flag_cuda': True
            },
        'linux_cpu':
            {
                'tmpl_flag_os': 'linux',
                'tmpl_flag_cuda': False
            },
    }

    for env in envs:
        with open('Pipfile.' + env, 'w') as f:
            rendered = render('Pipfile.tmpl',
                              envs[env])
            f.write(rendered)
