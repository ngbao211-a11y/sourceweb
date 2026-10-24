(function () {
  'use strict';

  var DOC = document;
  var WIN = window;
  var BODY = DOC.body;
  if (!BODY) return;

  var reducedMotionQuery = WIN.matchMedia && WIN.matchMedia('(prefers-reduced-motion: reduce)');
  var prefersReducedMotion = reducedMotionQuery && reducedMotionQuery.matches;

  var loader = DOC.createElement('div');
  loader.className = 'page-top-loader';
  loader.setAttribute('aria-hidden', 'true');

  var bar = DOC.createElement('div');
  bar.className = 'page-top-loader__bar';

  loader.appendChild(bar);
  BODY.appendChild(loader);

  var activeNav = false;
  var progressTimer = null;
  var progressValue = 0;

  function setBar(value) {
    progressValue = Math.max(0, Math.min(100, value));
    bar.style.width = progressValue + '%';
  }

  function startLoader() {
    if (activeNav) return;
    activeNav = true;
    loader.classList.add('active');
    setBar(10);

    progressTimer = WIN.setInterval(function () {
      if (progressValue < 80) {
        setBar(progressValue + Math.random() * 8);
      }
    }, 120);
  }

  function finishLoader() {
    if (!activeNav) return;
    if (progressTimer) {
      WIN.clearInterval(progressTimer);
      progressTimer = null;
    }
    setBar(100);
    WIN.setTimeout(function () {
      loader.classList.remove('active');
      setBar(0);
      activeNav = false;
    }, 220);
  }

  function isInternalLink(a) {
    if (!a || !a.href) return false;
    if (a.target && a.target.toLowerCase() === '_blank') return false;
    if (a.hasAttribute('download')) return false;
    var rel = (a.getAttribute('rel') || '').toLowerCase();
    if (rel.indexOf('external') !== -1) return false;
    if (a.origin !== WIN.location.origin) return false;
    if (a.getAttribute('href') && a.getAttribute('href').charAt(0) === '#') return false;

    var url = new URL(a.href, WIN.location.href);
    if (url.pathname === WIN.location.pathname && url.search === WIN.location.search && url.hash) return false;
    return true;
  }

  function startPageTransition() {
    startLoader();
    if (!prefersReducedMotion) {
      BODY.classList.add('page-transitioning');
    }
  }

  function preloadLink(href) {
    if (!href) return;
    if (DOC.head.querySelector('link[data-prefetch="' + href + '"]')) return;

    var link = DOC.createElement('link');
    link.rel = 'prefetch';
    link.href = href;
    link.as = 'document';
    link.setAttribute('data-prefetch', href);
    DOC.head.appendChild(link);
  }

  function wirePrefetch(anchor) {
    if (!anchor || anchor.__prefetchBound) return;
    anchor.__prefetchBound = true;

    var handler = function () {
      if (isInternalLink(anchor)) preloadLink(anchor.href);
    };

    anchor.addEventListener('mouseenter', handler, { passive: true });
    anchor.addEventListener('touchstart', handler, { passive: true });
    anchor.addEventListener('focus', handler, { passive: true });
  }

  function bindAnchors(root) {
    var anchors = (root || DOC).querySelectorAll('a[href]');
    for (var i = 0; i < anchors.length; i += 1) {
      wirePrefetch(anchors[i]);
    }
  }

  DOC.addEventListener('click', function (event) {
    if (event.defaultPrevented || event.button !== 0) return;
    if (event.metaKey || event.ctrlKey || event.shiftKey || event.altKey) return;

    var anchor = event.target.closest('a[href]');
    if (!isInternalLink(anchor)) return;

    startPageTransition();
  });

  WIN.addEventListener('pageshow', function () {
    BODY.classList.remove('page-transitioning');
    finishLoader();
  });

  WIN.addEventListener('load', function () {
    BODY.classList.remove('page-transitioning');
    finishLoader();
    bindAnchors(DOC);
  });

  if ('MutationObserver' in WIN) {
    var mo = new MutationObserver(function (mutations) {
      for (var i = 0; i < mutations.length; i += 1) {
        var nodes = mutations[i].addedNodes;
        for (var j = 0; j < nodes.length; j += 1) {
          var node = nodes[j];
          if (node.nodeType === 1) bindAnchors(node);
        }
      }
    });
    mo.observe(DOC.documentElement, { childList: true, subtree: true });
  }
})();