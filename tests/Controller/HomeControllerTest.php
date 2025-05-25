<?php

namespace App\Tests\Controller;

use PHPUnit\Framework\TestCase;

class HomeControllerTest extends TestCase
{
    public function testSimpleAssertion(): void
    {
        $result = $this->addNumbers(1, 1);
        $this->assertEquals(2, $result);
    }

    private function addNumbers(int $a, int $b): int
    {
        return $a + $b;
    }
}
