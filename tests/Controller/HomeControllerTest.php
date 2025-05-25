<?php

namespace App\Tests\Controller;

use PHPUnit\Framework\TestCase;

class HomeControllerTest extends TestCase
{
    public function testSimpleAssertion(): void
    {
        $this->assertTrue(true);
        $this->assertEquals(2, 1 + 1);
    }
}
