# ECDH-Curve25519
A pure Swift library for ECDH implementing Curve25519

Implementation of Curve25519 ECDH, based on work by Daniel J. Bernstein.

This is a quite 1:1 porting of frankigamez/ECDH-Curve25519 library originally written in C#.

**WARNING:** Despite all tests will succeds, this library is miles away to be production safe. Please test extensively before using in mission critical systems and let me know the results.

As of the GitHub spirit, any suggestion, modification are welcome.

# References
* D. J. Bernstein. ‘Curve25519: new Diffie-Hellman speed records’
http://cr.yp.to/ecdh/curve25519-20060209.pdf
* D. J. Bernstein. ‘Cryptography in NaCl’
https://cr.yp.to/highspeed/naclcrypto-20090310.pdf
* Múltiples Autores. ‘Verifying Curve25519 Software’
https://cryptojedi.org/papers/verify25519-20140824.pdf
* D. J. Bernstein y Tanja Lange. ‘Montgomery curves and the Montgomery ladder ’
https://eprint.iacr.org/2017/293.pdf
* D. J. Bernstein ‘The Salsa20 Core’
https://cr.yp.to/salsa20.html
