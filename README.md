Conspersa
=========

A dead project.


BUILD requirements.
------------------

Most of the requirements are taken care of by bundle.
System code needed to make bundle happy:
 * apt-get install cmake


Operational requirements.
------------------------

conspersa uses RabbitMQ.
To run this locally, using docker, one could do:
   % sudo docker run -d --hostname conspersa --name mq rabbitmq:3

