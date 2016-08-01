<?php

use Symfony\Component\HttpKernel\Kernel;
use Symfony\Component\Config\Loader\LoaderInterface;

class AppKernel extends Kernel
{
    public function registerBundles()
    {
        $bundles = [
            new Symfony\Bundle\FrameworkBundle\FrameworkBundle(),
            new Symfony\Bundle\SecurityBundle\SecurityBundle(),
            new Symfony\Bundle\TwigBundle\TwigBundle(),
            new Symfony\Bundle\MonologBundle\MonologBundle(),
            new Symfony\Bundle\SwiftmailerBundle\SwiftmailerBundle(),
            new Doctrine\Bundle\DoctrineBundle\DoctrineBundle(),

            new Polonairs\Dialtime\DialtimeBundle\DialtimeBundle(),
            new Polonairs\Dialtime\ModelBundle\ModelBundle(),
            new Polonairs\SmsiBundle\SmsiBundle(),
            new Polonairs\Dialtime\CommonBundle\CommonBundle(),
            new Polonairs\Dialtime\ServerBundle\ServerBundle(),
        ];

        if (in_array($this->getEnvironment(), ['dev', 'test'], true)) {
            $bundles[] = new Symfony\Bundle\DebugBundle\DebugBundle();
            $bundles[] = new Symfony\Bundle\WebProfilerBundle\WebProfilerBundle();
        }

        return $bundles;
    }

    public function getRootDir()
    {
        return __DIR__;
    }

    public function getCacheDir()
    {
        return '/var/cache/dialtime/server/'.$this->getEnvironment();
    }

    public function getLogDir()
    {
        return '/var/log/dialtime/server/';
    }

    public function registerContainerConfiguration(LoaderInterface $loader)
    {
        $loader->load('/etc/dialtime/server/config_'.$this->getEnvironment().'.yml');
    }
}
