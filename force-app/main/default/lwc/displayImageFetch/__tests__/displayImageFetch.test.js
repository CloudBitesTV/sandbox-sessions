import { createElement } from 'lwc';
import DisplayImageFetch from 'c/displayImageFetch';

const FETCH_DATA = require('./data/fetch.json');

describe('c-display-image-fetch', () => {
    afterEach(() => {
        // The jsdom instance is shared across test cases in a single file so reset the DOM
        while (document.body.firstChild) {
            document.body.removeChild(document.body.firstChild);
        }
    });

    // Helper function to mock a resolved fetch call.
    function mockFetch(data) {
        return jest
            .fn()
            .mockImplementation(() =>
                Promise.resolve({ ok: true, json: () => Promise.resolve(data) })
            );
    }

    async function flushPromises() {
        // eslint-disable-next-line @lwc/lwc/no-async-operation
        return new Promise((resolve) => setTimeout(resolve, 0));
    }

    it('will make the fetch request to pexels when loaded', async () => {
        // Arrange
        const element = createElement('c-display-image-fetch', {
            is: DisplayImageFetch
        });

        const fetch = (global.fetch = mockFetch(FETCH_DATA));

        // Act
        document.body.appendChild(element);
        
        await flushPromises();

        // Assert
        expect(fetch).toHaveBeenCalledTimes(1);
    });
});