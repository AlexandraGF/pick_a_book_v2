import React from 'react';
import ReactDOM from 'react-dom';
import HelloReact from './app';

describe('HelloReact', () => {
    it('renders without crashing', () => {
        const div = document.createElement('div');
        ReactDOM.render(<HelloReact />, div);
    });
});
